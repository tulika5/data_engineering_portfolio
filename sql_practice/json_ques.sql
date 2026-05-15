/*
Application teams write events into a single landing table with a flexible JSONB column. Downstream analytics needs a tabular view of two specific fields, but only when both are actually populated at the top level of the document.

You are given an events table with two columns:

event_id — INTEGER primary key
payload — JSONB document with arbitrary keys
Return one row per event whose payload document contains BOTH the top-level key user_id AND the top-level key event_type. For each qualifying row, project those two values as TEXT.

Important rules:

Only top-level keys count. If user_id or event_type appears only inside a nested object (for example payload -> 'context' -> 'user_id'), the event must NOT be returned.
A payload of {} (empty object) does not qualify.
If either key is present but its value is JSON null, the value must be projected as the SQL value NULL (not the string 'null').
Both columns must be returned as TEXT, even if the JSON values are numbers or booleans.
Output columns: event_id, user_id (TEXT), event_type (TEXT).

Ordering: sort by event_id ascending.*/


SELECT
    event_id,
    JSON_VALUE(payload, '$.user_id') AS user_id,
    JSON_VALUE(payload, '$.event_type') AS event_type
FROM events
WHERE JSON_PATH_EXISTS(payload, '$.user_id')
  AND JSON_PATH_EXISTS(payload, '$.event_type');
