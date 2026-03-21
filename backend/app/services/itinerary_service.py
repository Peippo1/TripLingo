from app.schemas.itinerary import ItineraryBlock, ItineraryRequest, ItineraryResponse


def generate_mock_itinerary(request: ItineraryRequest) -> ItineraryResponse:
    destination = request.destination.strip() or "your destination"
    preferences = _normalize_preferences(request.preferences)
    saved_places = [place.strip() for place in request.saved_places if place.strip()]
    prompt = request.prompt.strip()

    morning_activities = [
        _morning_opening(destination, preferences, prompt),
        _saved_place_line(saved_places, "morning", destination),
    ]

    afternoon_activities = [
        _afternoon_opening(destination, preferences),
        _afternoon_follow_up(destination, preferences, saved_places),
    ]

    evening_activities = [
        _evening_opening(destination, preferences),
        _evening_follow_up(destination, prompt),
    ]

    notes = [
        f"This is a mocked planning response for {destination}.",
        "The backend is ready for a future AI itinerary service integration.",
    ]
    if preferences:
        notes.append(f"Preferences considered: {', '.join(preferences)}.")
    if saved_places:
        notes.append(f"Saved places included where possible: {', '.join(saved_places[:2])}.")

    return ItineraryResponse(
        destination=destination,
        morning=ItineraryBlock(title="Morning", activities=morning_activities),
        afternoon=ItineraryBlock(title="Afternoon", activities=afternoon_activities),
        evening=ItineraryBlock(title="Evening", activities=evening_activities),
        notes=notes,
    )


def _normalize_preferences(preferences: list[str]) -> list[str]:
    ordered_unique: list[str] = []
    for preference in preferences:
        normalized = preference.strip()
        if normalized and normalized not in ordered_unique:
            ordered_unique.append(normalized)
    return ordered_unique


def _morning_opening(destination: str, preferences: list[str], prompt: str) -> str:
    if "caf" in " ".join(preferences).lower():
        return f"Start the day with coffee and a light breakfast in {destination}."
    if "relaxed" in " ".join(preferences).lower():
        return f"Begin with an easy-paced walk through a local neighborhood in {destination}."
    if prompt:
        return f"Start with a morning plan shaped around \"{prompt}\" in {destination}."
    return f"Start the day with a comfortable introduction to {destination}."


def _saved_place_line(saved_places: list[str], period: str, destination: str) -> str:
    if saved_places:
        return f"Use {saved_places[0]} as a {period} anchor while exploring {destination}."
    return f"Leave time for a flexible stop that feels local to {destination}."


def _afternoon_opening(destination: str, preferences: list[str]) -> str:
    joined = " ".join(preferences).lower()
    if "sight" in joined:
        return f"Spend the afternoon at one of {destination}'s major sights."
    if "food" in joined:
        return f"Plan the afternoon around a standout lunch and food stop in {destination}."
    return f"Use the afternoon for a balanced mix of exploration and downtime in {destination}."


def _afternoon_follow_up(destination: str, preferences: list[str], saved_places: list[str]) -> str:
    joined = " ".join(preferences).lower()
    if len(saved_places) > 1:
        return f"Continue toward {saved_places[1]} to add a personal stop to the route."
    if "shop" in joined:
        return f"Add time for shopping and browsing in a busy part of {destination}."
    return f"Pause for lunch and a short reset before continuing through {destination}."


def _evening_opening(destination: str, preferences: list[str]) -> str:
    joined = " ".join(preferences).lower()
    if "night" in joined:
        return f"Wrap up with a lively evening area and a late dinner in {destination}."
    if "food" in joined:
        return f"End with a memorable dinner that highlights local flavors in {destination}."
    return f"Finish the day with dinner and a relaxed walk in {destination}."


def _evening_follow_up(destination: str, prompt: str) -> str:
    if prompt:
        return f"Keep the evening aligned with your request: \"{prompt}\"."
    return f"Leave the final stop open so the plan can adapt once you are in {destination}."
