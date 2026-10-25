# Pathly Open Catalog schema

Generated from the Pathly app's data guide. Swift model names refer to the app's source files, copied into `validator/`.

## Relationships

```text
Organization
    │
    ├──────────────────┐
    ↓                  ↓
Opportunity          Place
    │                  ↑
    └── OpportunityLocation
```

An organization can own many opportunities and many places. An opportunity can connect to multiple places through `OpportunityLocation`; a place can likewise host multiple opportunities. Do not duplicate an opportunity merely because it has several locations.

## Opportunity schema

Swift model: `Models/Opportunity.swift`

| Field | JSON type | Required? | Meaning | Example |
| --- | --- | --- | --- | --- |
| `id` | String | Required | Stable internal ID matching `opp_######` | `opp_000123` |
| `name` | String | Required | Official opportunity name | `Swift Student Challenge` |
| `organization_id` | String or null | Optional | Existing organizer ID when normalized | `org_000042` |
| `image_asset_name` | String or null | Optional | Event artwork name in `Assets.xcassets`; falls back to the organization's logo | `opp_000123_visual` |
| `category` | Enum string | Required | Broad primary category | `Competition` |
| `subcategory` | String or null | Optional | More specific discipline/type | `App Development` |
| `description_short` | String | Required | Concise factual card/list summary | `Create an app playground...` |
| `description_full` | String or null | Optional | Longer factual description | `Participants submit...` |
| `interest_tags` | String array | Required | Controlled interests used for discovery | `["Programming", "Design"]` |
| `required_skills` | String array | Required | Skills explicitly required to participate | `["Swift"]` |
| `recommended_skills` | String array | Required | Helpful but non-mandatory skills | `["UI Design"]` |
| `min_grade` | Integer or null | Optional | Lowest eligible US grade | `6` |
| `max_grade` | Integer or null | Optional | Highest eligible US grade | `12` |
| `min_age` | Integer or null | Optional | Minimum age, when officially stated | `13` |
| `max_age` | Integer or null | Optional | Maximum age, when officially stated | `18` |
| `eligibility_notes` | String or null | Optional | Eligibility facts not captured structurally | `Must reside in...` |
| `team_type` | Enum string or null | Optional | Whether entry is individual, team, or either | `Individual or Team` |
| `min_team_size` | Integer or null | Optional | Smallest allowed team | `1` |
| `max_team_size` | Integer or null | Optional | Largest allowed team | `4` |
| `format` | Enum string | Required | Delivery/attendance format | `Hybrid` |
| `geographic_scope` | Enum string | Required | Geographic reach of the opportunity | `National` |
| `eligible_states` | String array | Required | USPS codes or the single value `ALL` | `["DE", "MD", "PA"]` |
| `eligible_countries` | String array | Required | Uppercase ISO two-letter country codes | `["US"]` |
| `online_available` | Boolean | Required | Whether participation is available online | `true` |
| `travel_required` | Boolean | Required | Whether participation requires travel | `false` |
| `cost_usd` | Number or null | Optional | Verified participant cost in US dollars | `0` |
| `financial_aid` | Boolean or null | Optional | Whether financial aid is confirmed available | `true` |
| `prize_value` | String or null | Optional | Factual award description, including ranges or non-cash awards | `Up to $5,000` |
| `application_open` | Date string or null | Optional | Date applications open | `2026-08-01` |
| `deadline` | Date string or null | Optional | Application/submission deadline | `2026-09-15` |
| `event_start` | Date string or null | Optional | Event/program start date | `2026-10-10` |
| `event_end` | Date string or null | Optional | Event/program end date | `2026-10-12` |
| `recurring` | Enum string | Required | Recurrence pattern | `Annual` |
| `recognition_level` | Enum string or null | Optional | Objective external-recognition tier | `High` |
| `selectivity_level` | Enum string | Required | How selective admission/advancement is | `Competitive` |
| `difficulty_level` | Enum string | Required | Expected participant challenge | `Intermediate` |
| `official_url` | URL string | Required | Official opportunity information page | `https://example.org/program` |
| `application_url` | URL string or null | Optional | Direct official application page | `https://example.org/apply` |
| `source_url` | URL string | Required | Authoritative page used for verification | `https://example.org/rules` |
| `last_verified` | Date string | Required | Most recent date facts were checked | `2026-08-21` |
| `status` | Enum string | Required | Current lifecycle status | `Open` |

Grades are numeric US K–12 grade levels. Do not invent a number for college-only eligibility; leave grade bounds `null` and explain the verified education-level requirement in `eligibility_notes` until a dedicated education-level field is added.

`cost_usd` remains numeric for filtering. `prize_value` is descriptive because real programs may offer ranges, multiple award tiers, travel, equipment, or other value that cannot be represented accurately by one number.

### Dates and deadlines

All dates use strict `YYYY-MM-DD` values. Do not use one generic date field, localized strings such as `10/12/26`, or a time value in these fields.

```json
{
  "application_open": "2026-08-01",
  "deadline": "2026-09-15",
  "event_start": "2026-10-10",
  "event_end": "2026-10-12"
}
```

Dates may be `null` when the official source has not announced them. Never copy a prior year's deadline into a current record unless the official source explicitly confirms it.

## Place schema

Swift model: `Models/Place.swift`

| Field | JSON type | Required? | Meaning | Example |
| --- | --- | --- | --- | --- |
| `id` | String | Required | Stable internal ID matching `place_######` | `place_000245` |
| `name` | String | Required | Official place/resource name | `Central Library` |
| `organization_id` | String or null | Optional | Existing owner/operator ID | `org_000031` |
| `image_asset_name` | String or null | Optional | Place-specific photo/artwork name in `Assets.xcassets`; otherwise the UI uses place-category artwork | `place_000245_visual` |
| `place_type` | Enum string | Required | Controlled physical resource type | `Makerspace` |
| `description` | String or null | Optional | Concise factual description | `Public fabrication lab...` |
| `address` | String or null | Optional | Street address | `123 Main Street` |
| `city` | String or null | Optional | City/locality | `Wilmington` |
| `state` | String or null | Conditional | USPS code for US places; region code where applicable | `DE` |
| `zip` | String or null | Optional | Postal code stored as text | `19801` |
| `country` | String | Required | Uppercase ISO two-letter country code | `US` |
| `latitude` | Number or null | Optional | WGS84 latitude from -90 through 90 | `39.7447` |
| `longitude` | Number or null | Optional | WGS84 longitude from -180 through 180 | `-75.5484` |
| `website` | URL string or null | Optional | Official place page | `https://example.org` |
| `phone` | String or null | Optional | Official public contact number | `+1-302-555-0100` |
| `free_access` | Boolean or null | Optional | Whether access is confirmed free | `true` |
| `membership_required` | Boolean or null | Optional | Whether membership is required | `false` |
| `resource_tags` | String array | Required | Physical services/equipment | `["3D Printers", "Laser Cutter"]` |
| `interest_tags` | String array | Required | Controlled interest taxonomy values | `["Engineering", "Design"]` |
| `verified` | Boolean | Required | Whether the record has been checked against an official source | `true` |
| `last_verified` | Date string | Required | Most recent verification date | `2026-08-21` |
| `status` | Enum string | Required | Current operating status | `Active` |

US places should use a USPS state code. Coordinates, when present, must be numeric JSON values and never quoted strings.

## Organization schema

Swift model: `Models/Organization.swift`

| Field | JSON type | Required? | Meaning | Example |
| --- | --- | --- | --- | --- |
| `id` | String | Required | Stable internal ID matching `org_######` | `org_000042` |
| `name` | String | Required | Official organization name | `Apple` |
| `organization_type` | Enum string | Required | Controlled organization classification | `Company` |
| `logo_asset_name` | String or null | Optional | Reusable organization logo name in `Assets.xcassets` | `org_000042_logo` |
| `website` | URL string or null | Optional | Official organization website | `https://www.apple.com` |
| `country` | String | Required | Headquarters/home uppercase ISO country code | `US` |
| `description` | String or null | Optional | Concise factual organization description | `Technology company...` |
| `verified` | Boolean | Required | Whether identity/details were checked | `true` |

Store organization facts once and reference them by ID. For example, an opportunity named Swift Student Challenge should reference Apple's organization record rather than repeating Apple details inside the opportunity.

## Opportunity-location schema

Swift model: `Models/OpportunityLocation.swift`

| Field | JSON type | Required? | Meaning | Example |
| --- | --- | --- | --- | --- |
| `opportunity_id` | String | Required | Existing opportunity ID | `opp_000123` |
| `place_id` | String | Required | Existing place ID | `place_000245` |

The pair must be unique. Add one relationship object per location; never clone the opportunity record.

## Controlled vocabularies

The canonical Swift definitions live in `Models/PathlyEnums.swift`. JSON values are case- and punctuation-sensitive. An unrecognized value intentionally causes decoding to fail so errors are found before inconsistent data reaches the app.

| Vocabulary | Allowed values |
| --- | --- |
| Opportunity category | Competition; Hackathon; Research; Internship; Scholarship; Program; Camp; Workshop; Event; Volunteering; Leadership; Club; Fellowship; Grant |
| Place type | Library; Makerspace; Fab Lab; Museum; Science Center; University; Robotics Club; Community Center; Hackerspace; Observatory; Innovation Lab; Youth Center |
| Interest | Computer Science; Programming; Artificial Intelligence; Cybersecurity; Robotics; Engineering; Electronics; Science; Biology; Chemistry; Physics; Medicine; Mathematics; Space; Environment; Business; Entrepreneurship; Finance; Economics; Writing; Journalism; Art; Design; Music; Film; Game Development; Public Policy; Debate; Community Service |
| Format | Online; In-Person; Hybrid |
| Geographic scope | Local; County; Congressional District; State; Regional; National; International; Anywhere |
| Opportunity status | Open; Upcoming; Closed; Expired; Unknown |
| Place status | Active; Temporarily Closed; Closed; Unknown |
| Recognition | Local; Regional; State; Strong; High; Exceptional |
| Selectivity | Open; Competitive; Selective; Highly Selective; Unknown |
| Difficulty | Beginner; Intermediate; Advanced; Expert; Unknown |
| Team type | Individual; Team; Individual or Team |
| Recurrence | One-Time; Annual; Seasonal; Monthly; Recurring; Unknown |
| Organization type | Company; Nonprofit; Government; University; School; Library; Foundation; Community Organization; Professional Organization; Other |

Primary categories remain broad. A robotics contest is `category = Competition` and `subcategory = Robotics`, not a new `Robotics Competition` category. Extend a vocabulary by updating both `PathlyEnums.swift` and this table in the same change.

### Recognition is not an admissions score

`recognition_level` is not “good for Harvard,” a college-admissions score, a quality judgment, or a promise of student outcomes. It may eventually summarize objective signals such as geographic scope, organizer, judged submission, selectivity, participant count, advancement structure, award level, and external validation. There is no recognition algorithm yet. Leave the field `null` rather than guessing.

### User-specific matching does not belong in records

Never add fields such as `match`, `skill_match`, or `excellent_match` to an opportunity. Pathly will calculate those later by comparing a user profile with stable opportunity facts: interests, skills, grade, age, eligibility, location, travel distance, cost preference, format preference, and category preference. The same opportunity may be an excellent skill match for one student and a stretch opportunity for another.

## State and online handling

All states remain in the same national dataset. Do not create separate files or databases per state.

Use a single `ALL` value for nationwide US eligibility:

```json
"eligible_states": ["ALL"]
```

Use uppercase two-letter USPS abbreviations for limited eligibility:

```json
"eligible_states": ["DE", "MD", "PA"]
```

Do not combine `ALL` with individual state codes. Online describes delivery format, not eligibility. This is valid:

```json
{
  "format": "Online",
  "eligible_states": ["DE"],
  "eligible_countries": ["US"]
}
```

An online listing does not automatically become national or international.

## Stable ID convention

- Opportunities: `opp_000001`, `opp_000002`, ...
- Places: `place_000001`, `place_000002`, ...
- Organizations: `org_000001`, `org_000002`, ...

IDs are permanent database identities, not display names. Never derive them from a human-readable name, change them when a name changes, recycle an ID from a deleted record, or renumber existing records to close gaps.

## Data-quality rules

- Never invent missing information. Prefer `null`, an empty array where semantically appropriate, or `Unknown` when that enum supports it.
- Prefer official and authoritative sources. Aggregator pages can help discovery but should not override official facts.
- Never guess deadlines or eligibility requirements.
- Do not duplicate organizations, opportunities, places, or opportunity-place pairs.
- Keep spelling, capitalization, punctuation, and enum values consistent.
- Keep every date in strict `YYYY-MM-DD` format.
- Update `last_verified` every time an opportunity or place is genuinely checked.
- Do not mark `verified` true merely because a record contains plausible information.
- Do not store user-specific match ratings in the dataset.
- Do not create state-specific dataset files.
- Do not use empty strings for unknown optional values; use `null`.
- Keep skills factual and consistently named. Skills remain strings so the vocabulary can evolve before a dedicated skill taxonomy is finalized.
