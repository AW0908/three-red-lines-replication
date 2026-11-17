"""Record the T093 number-check stop; do not build or alter the approved page.

Offline evidence only. The source manifest's payload size is uncompressed and
cannot substantiate the template's compressed ZIP-size claim.
"""
import csv
import hashlib
import json
from pathlib import Path

OUT = Path(__file__).resolve().parents[2]
VAL = OUT / 'release/validation'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    with path.open(encoding='utf-8', newline='') as stream:
        return list(csv.DictReader(stream))


def write(path, fields, rows):
    with path.open('w', encoding='utf-8', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


receipt = VAL / 'T093_FILES_STOP.json'
assert not receipt.exists(), 'Retain the previous stop receipt; do not overwrite it.'
manifest = OUT / 'release/MANIFEST.csv'
rows = read(manifest)
included = [row for row in rows if row['status'] == 'included']
assert all((OUT / row['file']).stat().st_size == int(row['size_bytes'])
           and sha(OUT / row['file']) == row['sha256'] for row in included)
payload = sum(int(row['size_bytes']) for row in included)
template = OUT.parent / 'state/website/website_template.html'
claim = 'Download everything (ZIP, about 450 MB)'
assert claim in template.read_text()
evidence = {
    'result': 'STOP: number not confirmed',
    'claim': claim,
    'claim_source': 'state/website/website_template.html',
    'claim_source_sha256': sha(template),
    'manifest_before_evidence': {
        'file': 'release/MANIFEST.csv', 'sha256': sha(manifest),
        'included_files': len(included), 'verified_size_and_hash_mismatches': 0,
        'included_payload_bytes': payload,
        'decimal_MB': payload / 1_000_000, 'binary_MiB': payload / 1_048_576,
        'convention': 'included rows only; excludes MANIFEST itself and withheld rows',
    },
    'limitation': 'Payload bytes are uncompressed. No compressed ZIP size is '
                  'recorded by the manifest; 450 MB ZIP cannot be confirmed. '
                  'No ZIP was downloaded or generated.',
    'page_sha256_unchanged': sha(OUT / 'docs/index.html'),
    'release_template_sha256_unchanged': sha(OUT / 'release/release_tools/site_template.html'),
    'action': 'Stopped before template copy and build, as required by T093. '
              'Only stop evidence, numeric audit and payload manifest updated. '
              'Historical baselines and earlier audit rows retained.',
}
receipt.write_text(json.dumps(evidence, indent=2) + '\n')
numbers = VAL / 'T093_NUMBERS.csv'
audit = read(numbers)
audit.append(dict(number_on_page='about 450 MB (ZIP)',
    page_location='Browse the files / Download everything (new template, not built)',
    source='release/MANIFEST.csv included size_bytes; source hash and exact sum '
           'in release/validation/T093_FILES_STOP.json',
    recomputed_value=f'{payload} payload bytes = {payload / 1_000_000:.6f} MB '
                     '(uncompressed); ZIP size unconfirmed',
    match='no', status='STOP: unconfirmed size; previous audit rows retained'))
write(numbers, list(audit[0]), audit)
files = sorted(path for path in OUT.rglob('*') if path.is_file()
               and '.git' not in path.relative_to(OUT).parts and path != manifest)
entries = [dict(file=path.relative_to(OUT).as_posix(), status='included',
                size_bytes=path.stat().st_size, sha256=sha(path)) for path in files]
entries += [row for row in rows if row['status'] == 'withheld']
write(manifest, ['file', 'status', 'size_bytes', 'sha256'], entries)
assert all((OUT / row['file']).stat().st_size == int(row['size_bytes'])
           and sha(OUT / row['file']) == row['sha256']
           for row in read(manifest) if row['status'] == 'included')
print(f'T093 STOP: source MANIFEST verified {len(included)} files, '
      f'{payload} payload bytes ({payload / 1_000_000:.6f} MB).')
print('ZIP about 450 MB: unconfirmed; no template copy or build executed.')
print(f'Evidence and match=no retained; MANIFEST refreshed for {len(files)} payload files.')
