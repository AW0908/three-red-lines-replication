# Provider selection and CLI adapters; source from project root. No task/status mutation.
source "${MTPA_PROVIDER_CONFIG:-agents/providers.conf}"
provider_name() {
  case "$1" in codex|claude|agy) echo "$1" ;; antigravity) echo agy ;; *) echo "Unbekannter Provider: $1" >&2; return 1 ;; esac
}
# Explicit role override > reviewer-wide override > global default.
# Historical card tool names are metadata and intentionally do not select a provider.
select_provider() {
  local role="$1" selected=""
  case "$role" in
    worker) selected="${MTPA_WORKER_PROVIDER:-}" ;;
    co-pi) selected="${MTPA_CO_PI_PROVIDER:-}" ;;
    data) selected="${MTPA_REVIEWER_DATA_PROVIDER:-${MTPA_REVIEWER_PROVIDER:-}}" ;;
    estimation) selected="${MTPA_REVIEWER_ESTIMATION_PROVIDER:-${MTPA_REVIEWER_PROVIDER:-}}" ;;
    consistency) selected="${MTPA_REVIEWER_CONSISTENCY_PROVIDER:-${MTPA_REVIEWER_PROVIDER:-}}" ;;
    language) selected="${MTPA_REVIEWER_LANGUAGE_PROVIDER:-${MTPA_REVIEWER_PROVIDER:-}}" ;;
    general) selected="${MTPA_REVIEWER_PROVIDER:-}" ;;
    *) echo "Unbekannte Rolle: $role" >&2; return 1 ;;
  esac
  provider_name "${selected:-$MTPA_DEFAULT_PROVIDER}"
}
# Role- and provider-specific model (MTPA_<ROLE>_<PROVIDER>_MODEL); empty if unset.
role_model() {
  local role="$1" provider key
  provider="$(provider_name "$2")" || return
  case "$role" in
    worker) key=WORKER ;; co-pi) key=CO_PI ;;
    data|estimation|consistency|language|general) key="REVIEWER_$(printf '%s' "$role" | tr 'a-z' 'A-Z')" ;;
    *) echo "Unbekannte Rolle: $role" >&2; return 1 ;;
  esac
  key="MTPA_${key}_$(printf '%s' "$provider" | tr 'a-z' 'A-Z')_MODEL"
  printf '%s' "${!key:-}"
}
# Non-Codex reviewers fail closed if the OS read-only wrapper is unavailable.
readonly_provider() {
  command -v sandbox-exec >/dev/null || { echo 'read-only OS-Sandbox (sandbox-exec) fehlt; kein unsicherer Fallback.' >&2; return 1; }
  sandbox-exec -p '(version 1) (allow default) (deny file-write*)' "$@"
}
# run_provider PROVIDER MODE EFFORT PROMPT [OUTPUT LOG]; MODE=worker/reviewer/co-pi.
# Callers may set MTPA_ROLE_MODEL for one call (from role_model); it overrides the provider model.
run_provider() {
  local provider="$1" mode="$2" effort="$3" prompt="$4" out="${5:-}" log="${6:-}" model=""
  local -a cmd model_args
  case "$effort" in high|medium|low) ;; *) echo 'Aufwand muss high/medium/low sein.' >&2; return 1 ;; esac
  provider="$(provider_name "$provider")" || return
  case "$provider" in
    codex)
      model="${MTPA_ROLE_MODEL:-${MTPA_CODEX_MODEL:-}}"; model_args=(); [[ -z "$model" ]] || model_args=(-m "$model")
      if [[ "$mode" == co-pi ]]; then
        codex -a on-request -s workspace-write -c model_reasoning_effort="$effort" ${model_args[@]+"${model_args[@]}"} "$prompt"; return
      fi
      local sandbox=workspace-write; [[ "$mode" != reviewer ]] || sandbox=read-only
      codex -a never exec --ephemeral --skip-git-repo-check -c model_reasoning_effort="$effort" ${model_args[@]+"${model_args[@]}"} -s "$sandbox" -o "$out" "$prompt" < /dev/null > "$log" 2>&1
      ;;
    claude)
      model="${MTPA_ROLE_MODEL:-${MTPA_CLAUDE_MODEL:-}}"; model_args=(); [[ -z "$model" ]] || model_args=(--model "$model")
      if [[ "$mode" == co-pi ]]; then
        claude --effort "$effort" ${model_args[@]+"${model_args[@]}"} --permission-mode plan "$prompt"; return
      fi
      cmd=(claude -p "$prompt" --effort "$effort" ${model_args[@]+"${model_args[@]}"} --no-session-persistence)
      if [[ "$mode" == reviewer ]]; then
        # Claude needs its (empty) temp dir to exist; create it outside the write-denying sandbox.
        mkdir -p "/tmp/claude-$(id -u)" 2>/dev/null || true
        readonly_provider "${cmd[@]}" --permission-mode dontAsk --tools Read,Glob,Grep --allowedTools Read,Glob,Grep --strict-mcp-config --mcp-config '{"mcpServers":{}}' --disable-slash-commands < /dev/null > "$out" 2> "$log"
      else
        "${cmd[@]}" --permission-mode acceptEdits --permission-prompts none < /dev/null > "$out" 2> "$log"
      fi
      ;;
    agy)
      model="${MTPA_ROLE_MODEL:-${MTPA_AGY_MODEL:-}}"; model_args=(); [[ -z "$model" ]] || model_args=(--model "$model")
      if [[ "$mode" == co-pi ]]; then
        agy --effort "$effort" ${model_args[@]+"${model_args[@]}"} --mode plan --prompt-interactive "$prompt"; return
      fi
      cmd=(agy --effort "$effort" ${model_args[@]+"${model_args[@]}"} --print-timeout 900s --print "$prompt")
      if [[ "$mode" == reviewer ]]; then
        readonly_provider "${cmd[@]}" --mode plan --disable-slash-commands < /dev/null > "$out" 2> "$log"
      else
        "${cmd[@]}" --mode accept-edits --sandbox < /dev/null > "$out" 2> "$log"
      fi
      ;;
  esac
}
