# Referee-mirror identity inventory

T084_ANONYMITY.csv enumerates each matched occurrence (file, line, offset, category and
inspection channel), including author given/family name, account, standalone initials and
emails. Matching is case-insensitive for names/account. Text, raw bytes, PDF extracted text,
PDF metadata and PNG textual metadata are inspected. A match in more than one channel is
reported in each channel. Generated occurrence reports use category labels and contain no
identifying values. The scanner source's pattern declarations are themselves inventoried.

The named release retains attribution in licences and historical records. The anonymous
mirror's configured word replacements require a fresh scan of its actual exported content;
no mirror export or network access was available here. Initials may be ordinary acronyms
and still require PI review. PDF/image appearance may retain identity even when text
replacements run. Original team-diagram text was inspected locally; no OCR of every image
or arbitrary steganographic payload is claimed. PNG textual metadata is decoded.

Existing .git is excluded from payload and is untouched. T084_GIT_IDENTITY.csv separately
inventories matching names/accounts/initials/emails in transport text and loose commit/tag
headers, using read-only Python decoding; no Git command was run. Email values are represented
by hashes, never copied into the public payload. T084_GIT_SCAN.json records coverage and any
packed objects that could not be inspected. Strip transport metadata from a mirror export.
Dates, institution/course,
project history and provider/model choices can indirectly identify the author; word replacement
does not establish full anonymity. The PI must decide whether to withhold those records or
use a separate referee archive. This is an inventory, not anonymous-mirror certification.
