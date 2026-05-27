# Data Dictionary

## digital_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable object identifier |
| title | Human-readable title |
| object_type | book, image, map, audio, web_archive, collection, authority, subject, rights, preservation |
| has_metadata | Whether sufficient descriptive metadata exists |
| has_subject | Whether subject access exists |
| has_rights | Whether rights/access metadata exists |
| has_preservation | Whether preservation context exists |
| status | active, review_needed, restricted, deprecated |

## digital_library_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source object or record |
| relationship_type | Typed relationship predicate |
| target_object_id | Target object or record |
| provenance_note | Evidence or record note supporting the relationship |
| status | active, provisional, deprecated |
