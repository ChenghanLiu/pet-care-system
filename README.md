# Agricultural Information Management System

This repository keeps the original `wine_shop` schema and backend API structure, but the frontend presentation is adapted for an agricultural information management demo.

## Data Entry Mapping

Use the existing tables and fields as an agricultural content mapping layer. Do not rename tables or change API contracts.

| Existing field | Agricultural meaning | Data entry guidance |
| --- | --- | --- |
| `ws_product.name` | Agricultural Title | Enter the topic title shown on list/detail pages. |
| `ws_product.description` | Agricultural Content | Enter crop notes, technical summary, or information text. |
| `ws_product.cover_image` | Cover Image | Use a stable image URL for the information card/detail cover. |
| `ws_product.price` | Reference Index | Store a display-only reference indicator used by the frontend. |
| `ws_product.stock` | Resource Level | Store a resource level / reserve value for demo display. |
| `ws_product.sales` | Popularity Index | Store a popularity or attention metric for demo display. |
| `ws_category.name` | Primary Topic | Maintained as the first-level agricultural topic. |
| `ws_subcategory.name` | Secondary Topic | Maintained as the second-level agricultural topic. |
| `ws_notice.title` | Notice Title | Use for platform notices or agricultural news headings. |
| `ws_notice.content` | Notice Content | Use for notices, updates, or agricultural information text. |
| `ws_banner.title` | Banner Title | Use for homepage agricultural topic highlights. |
| `ws_banner.link_url` | Display Note / Link | Can hold a route path or a short banner explanation. |

## Startup Stability

- If the database schema exists but admin/user records are empty, `DemoAccountInitializer` recreates:
- `admin / admin123`
- `user1 / 123456`
- `data_init.sql` is still compatible with the original schema and can seed demo records without schema changes.
