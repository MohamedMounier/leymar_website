# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter run -d chrome    # Run on web
flutter analyze          # Static analysis
flutter build web        # Web release build
```

---

## Project Overview

**Project Name:** Ylmar Website

Ylmar is a luxury industrial textile manufacturer. This is not a company website — it is a **Luxury Industrial Digital Experience** that must feel like Apple, Rolls-Royce, or Bentley, not a factory site.

**Products:** Elastic Bands, Jacquard Elastic, Waistband Elastic, Drawcords, Woven Tapes, Webbing, Garment Accessories, Custom Textile Solutions.

---

## Design Philosophy

**Direction:** Industrial Luxury + Textile Heritage + Modern Motion Design

**Keywords:** Luxury · Precision Engineering · Textile Heritage · Innovation · Motion · Industrial Elegance

**Inspired by:** Apple, Rolls-Royce, Bentley, Bang & Olufsen

**Never:** generic corporate layouts, Bootstrap appearance, template grids, plain cards, repeated section patterns, anything resembling SJ Elastic or traditional factory sites. Every section must feel custom-designed.

---

## Color Palette

**Direction: LIGHT luxury** — warm ivory canvas, deep royal-navy ink, antique-gold accents (matches the logo: gold loom + serif wordmark on navy jacquard). Navy is now an accent/ink color, not the background. Use deep navy only as deliberate feature strips (footer, CTA bands, the globe).

| Role | Name | Hex |
|---|---|---|
| Background | Porcelain Ivory | `#FBF8F2` |
| Surface Alt | Champagne Sand | `#F3ECDF` |
| Cards | Pristine White | `#FFFFFF` |
| Primary (navy ink) | Deep Sapphire | `#0D2D66` |
| Primary Dark | Royal Midnight | `#071B3B` |
| Accent (text-safe gold) | Deep Antique Gold | `#A9781E` |
| Gold (metallic fills) | Brand Gold | `#C79A3B` |
| Highlight | Champagne Gold | `#E0BC74` |
| Text Primary | Deep Navy Ink | `#0B1E3F` |
| Text Secondary | Slate | `#55607A` |
| Divider | Warm Hairline | `#E7DFCF` |

---

## Technical Stack

- **Framework:** Flutter Web only
- **State management:** `flutter_bloc` — Cubit only, never raw Bloc
- **Architecture:** MVC
- **No backend, no database** — all data from local JSON files in `lib/data/json/`

**Folder structure:**
```
lib/
  core/
    constants/
    theme/
    animations/
    widgets/
    extensions/
  models/
  data/
    json/
  repositories/
  cubits/
  views/
  routes/
  main.dart
assets/
  images/
  videos/
  lottie/
  json/
```

---

## Theme System

All styling through a centralized theme — no magic values, no hardcoded colors, no inline styling.

Required in `lib/core/theme/`:
- `AppColors` — the palette above
- `AppTextStyles`
- `AppSpacing`
- `AppShadows`
- `AppAnimations`

---

## Animation Stack

**Packages:** `flutter_animate`, `animate_do`, `lottie`, `rive`, `visibility_detector`, `scrollable_positioned_list`, `flutter_staggered_animations`

**Rules:** Every major section must contain motion. Prefer Fade, Slide, Scale, Reveal, Parallax, mouse/hover interactions. Desktop hover is mandatory.

**Avoid:** flashy effects, excessive bouncing, cheap transitions.

**Signature effect — Live Thread Animation:** golden threads move slowly across the entire site via `CustomPainter` (Thread Network Animation). Yarn particles follow mouse cursor on desktop.

---

## Responsive Strategy

**Package:** `flutter_screenutil` — never hardcode dimensions.

| Breakpoint | Range | Columns | Navigation |
|---|---|---|---|
| Mobile | 0–767 | 1 | Drawer |
| Tablet | 768–1199 | 2 | Floating Nav |
| Desktop | 1200+ | 4 | Mega Menu |

---

## Cubits

Each feature owns one Cubit. Business logic never lives in UI widgets.

`HomeCubit` · `ProductsCubit` · `CapabilitiesCubit` · `FactoryCubit` · `ResourcesCubit` · `ThemeCubit` · `ContactCubit`

---

## Page Structure

```
Home · About Ylmar · Capabilities · Products · Custom Manufacturing ·
Industries · Technology · Factory Tour · Quality Assurance ·
Global Clients · Resources · Contact
```

---

## Section Specs

### Hero
- Background: short looping video (loom machines, elastic production, threads, machinery)
- Effects: Parallax, particle threads, smooth zoom
- Logo centered, animated entrance
- Headline: *"Engineering Flexibility. Weaving Excellence."*
- CTAs: **Explore Products** · **Request Quote**
- Animated textile threads in background throughout scroll

### Products Preview
- No plain cards — each product is a **Floating Glass Tile**
- Hover: slight rotation + shadow expand + golden glow
- Categories: Elastic Bands · Jacquard Elastic · Waistband Elastic · Drawcords · Webbing · Tapes · Garment Accessories · Custom Solutions

### Product Detail Page
- 3D Swiper gallery
- Animated specification table
- Interactive color picker
- Animated width chips
- Applications: Fashion · Sportswear · Underwear · Medical · Industrial

### Manufacturing Process
- Horizontal animated timeline: Yarn Selection → Dyeing → Weaving → Inspection → Packaging → Export
- Each step animates into view on scroll

### Factory Tour
- Drone video + 360 photos
- Animated counters (trigger on scroll reach):
  - 150+ Machines
  - 25M Meters Annually
  - 50+ Countries
  - 30 Years Experience

### Technology
- Apple-style scroll-driven animation
- On scroll: machines move → threads gather → textile forms in front of user

### Industries Served
- Interactive map: Fashion · Sports · Medical · Military · Furniture · Automotive

### Sustainability
- Animated infographics: Water Saving · Recycled Materials · Energy Efficiency

### Quality Assurance
- Certificates: OEKO-TEX · ISO · GRS · Custom
- Tap to open Lightbox viewer

### Global Reach
- 3D interactive globe (`flutter_cube` or `three_dart`)
- Animated gold lines to export destinations

### Client Showcase
- Logo wall, auto-scroll, luxury animation

### Resources Center
- Blog-style articles (e.g., "Choosing Elastic Width", "Custom Jacquard Guide", "Garment Accessories Trends")

### Contact
- Animated textile background
- Request Quote form: Upload Design · MOQ · Country · Email · Phone
- WhatsApp CTA · Email · Phone · Address
- Local only — no backend

---

## JSON Product Schema

```json
{
  "id": 1,
  "title": "Jacquard Elastic",
  "description": "Premium woven elastic.",
  "image": "assets/products/jacquard.jpg",
  "colors": ["#000000", "#FFFFFF"],
  "sizes": ["20mm", "30mm", "40mm"]
}
```

Full product fields: `id`, `name`, `category`, `description`, `specifications`, `applications`, `colors`, `widths`, `images`.

---

## Performance

Target 90+ Lighthouse score. Lazy loading, image optimization, efficient animations, minimal rebuilds, `const` constructors everywhere possible. Avoid unnecessary widget nesting.

---

## Coding Standards

- SOLID principles, strong typing, null safety
- Single responsibility per file — no God classes, no duplicate code
- Reusable widgets in `lib/core/widgets/`

---

## Asset Rules

Textile-related only: loom machines, elastic bands, manufacturing processes, factory environments, threads, fabrics. All assets reinforce the luxury industrial brand identity.

---

## What Makes Ylmar Unique

These elements must distinguish the site from all competitors:

1. Live thread / yarn network animation across the entire site (`CustomPainter`)
2. Product cards that appear woven from threads on hover
3. Interactive weaving process visualization
4. 3D globe export map with animated gold lines
5. Scroll-triggered factory statistics counters
6. Textile-inspired page transitions
7. Gold/blue identity strictly matching the logo
8. Dynamic machine background effects
9. Animated yarn particles following mouse on desktop
10. Full cinematic hero with video and parallax

If executed correctly, Ylmar will read as a European luxury brand, not a factory website.
