INSERT OR IGNORE INTO metadata_fields (field_name, field_type, required, description) VALUES
('title', 'text', 1, 'Human-readable article title'),
('slug', 'text', 1, 'Stable URL slug'),
('series', 'text', 1, 'Knowledge series name'),
('status', 'text', 1, 'Publication or workflow status'),
('concepts', 'array', 0, 'Primary concept tags'),
('relationships', 'array', 0, 'Linked semantic relationships');
