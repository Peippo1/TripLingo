# CityScout Roadmap

## V1 – City-First Travel Companion (Current Phase)

### Core Features (Complete / In Progress)
- City-first navigation flow (Onboarding → Destination → Scoped Experience).
- Seeded lesson content across multiple cities (Barcelona, Paris, Athens, Rome, Helsinki, Copenhagen, Lisbon).
- Phrasebook with save, recent tracking, and search.
- Explore (Points of Interest) with ability to save to Map.
- Map with destination-scoped saved places.
- Apple Translate integration for quick phrase translation.
- Reusable City Header with destination context and local city time.
- Robust SwiftData seed bootstrap with idempotent import and failure-safe UI states.
- CI pipeline building and testing on `dev` branch.

### Quality & Polish (Next Priority)
- Improve loading and empty states across all features.
- Accessibility pass (Dynamic Type, VoiceOver labels, contrast checks).
- Add placeholder app icon and basic branding.
- Minor UI polish (spacing, transitions, consistency across tabs).
- Ensure consistent tone and copy across all screens.

### Release Readiness Checklist
- All core flows manually verified on simulator.
- No critical crashes or blocking navigation issues.
- Seed import verified stable across fresh installs.
- CI pipeline consistently green.
- Internal test build ready for sharing.

---

## V1.1 – Usability & Experience Upgrades

### UX Improvements
- Tap map annotations → show place detail card.
- Improved saved places list and management UI.
- Refined onboarding flow (clearer value + smoother transitions).
- Better destination switching UX.
- Explore categories and filtering (Food, Sights, Cafes, etc.) with lightweight UI tagging

### Learning Enhancements
- Add audio pronunciation (basic TTS).
- Improve lesson progression and feedback.

### General Improvements
- Performance optimisation (reduce unnecessary view updates).
- Improve perceived responsiveness across navigation.

---

## V2 – AI-Assisted Travel Layer

### Core AI Features
- AI-enhanced translation (context-aware, tone-aware).
- “Explain this phrase” functionality.
- Smart phrase suggestions based on situation.
- Chat-based travel assistant (text-first).
- Interactive AI trip planning assistant (e.g. "What are good restaurants in Rome?", "What events are on?", "What should I see?")
- Context-aware recommendations based on destination, saved places, and user preferences
- Conversational discovery (e.g. "Find me a coffee near my hotel")

### Architecture
- Feature-flag AI components.
- Preserve offline-first baseline when AI unavailable.
- Introduce API layer (OpenAI) with clear boundaries.

### Safety & Control
- Usage limits / cost control.
- Error handling and graceful fallbacks.

### Voice & Interaction Layer
- Speech-to-text for conversational interaction with AI assistant
- Text-to-speech responses for hands-free usage
- Pronunciation practice mode for language learning
- Dual-purpose voice system (learning + in-trip discovery)

---

## V3 – Full Travel Companion

### Product Expansion
- Voice mode (speech → translate → playback).
- Offline downloadable city packs.
- Weather integration.
- Lightweight trip planning (notes, saved places, scheduling).

### Platform Growth
- App Store release.
- Multi-language UI support.
- Scaling architecture for many destinations.

---

## Long-Term Vision

CityScout evolves from a simple phrase-learning tool into a fully integrated, intelligent travel companion that:
- Works offline by default
- Enhances real-world travel experiences
- Scales across cities, languages, and user journeys

The core principle remains:

> A fast, reliable, and intuitive city-first experience — with AI as an enhancement, not a dependency.
