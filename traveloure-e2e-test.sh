#!/bin/bash

# Traveloure Platform E2E API Testing
# Testing Maya's 5-day Kyoto trip (April 1-5, 2026)

BASE_URL="http://localhost:5000/api"
TEST_EMAIL="maya.kyoto.test@example.com"
TEST_PASSWORD="Test123!@#"
EXPERT_EMAIL="kyoto.expert@example.com"
EXPERT_PASSWORD="ExpertTest123!@#"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables for test results
TOTAL_STEPS=0
WORKING_STEPS=0
PARTIAL_STEPS=0
BROKEN_STEPS=0
NOT_WIRED_STEPS=0

# Logged-in user auth token
AUTH_TOKEN=""
TRIP_ID=""
ITINERARY_ID=""
EXPERT_ID=""

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}Traveloure Platform E2E API Testing${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Function to test an endpoint
test_endpoint() {
    local step=$1
    local endpoint=$2
    local method=$3
    local data=$4
    local expected_status=$5
    local description=$6

    TOTAL_STEPS=$((TOTAL_STEPS + 1))

    echo -e "${BLUE}Step ${step}: ${description}${NC}"
    echo "Route: ${endpoint}"

    # Prepare curl command
    local curl_cmd="curl -s -X ${method} ${BASE_URL}${endpoint}"

    # Add auth header if we have a token
    if [ -n "$AUTH_TOKEN" ]; then
        curl_cmd="${curl_cmd} -H 'Authorization: Bearer ${AUTH_TOKEN}'"
    fi

    curl_cmd="${curl_cmd} -H 'Content-Type: application/json'"

    if [ -n "$data" ]; then
        curl_cmd="${curl_cmd} -d '${data}'"
    fi

    curl_cmd="${curl_cmd} -w '\n%{http_code}'"

    # Execute and capture response
    response=$(eval $curl_cmd)
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n-1)

    echo "Status: $http_code"

    # Parse response
    if echo "$body" | jq . &>/dev/null 2>&1; then
        echo "Response (JSON):"
        echo "$body" | jq . | head -30
    else
        echo "Response (Text):"
        echo "$body" | head -10
    fi

    # Check status
    if [ "$http_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ WORKS${NC}"
        WORKING_STEPS=$((WORKING_STEPS + 1))
        status="WORKS"
    elif [ "$http_code" = "000" ] || [ -z "$http_code" ]; then
        echo -e "${YELLOW}🔌 NOT WIRED${NC}"
        NOT_WIRED_STEPS=$((NOT_WIRED_STEPS + 1))
        status="NOT WIRED"
    else
        echo -e "${RED}❌ BROKEN (Expected $expected_status, got $http_code)${NC}"
        BROKEN_STEPS=$((BROKEN_STEPS + 1))
        status="BROKEN"
    fi

    echo ""
    return 0
}

# STEP 1: Auth & Sign Up
echo -e "${YELLOW}========== STEP 1: Auth & Sign Up ==========${NC}"
echo ""

# Test signup
test_endpoint "1.1" "/auth/signup" "POST" \
    "{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\",\"name\":\"Maya Test\"}" \
    "200" \
    "POST /api/auth/signup - Create account"

# Extract auth token from signup response (simplified - assumes it returns token)
AUTH_TOKEN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/signup" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\",\"name\":\"Maya Test\"}")

if echo "$AUTH_TOKEN_RESPONSE" | jq -e '.token' &>/dev/null 2>&1; then
    AUTH_TOKEN=$(echo "$AUTH_TOKEN_RESPONSE" | jq -r '.token')
    echo "Extracted Auth Token: ${AUTH_TOKEN:0:20}..."
fi

# Test get user
test_endpoint "1.2" "/auth/user" "GET" "" "200" "GET /api/auth/user - Verify logged in"

echo ""

# STEP 2: Create Trip
echo -e "${YELLOW}========== STEP 2: Create Trip ==========${NC}"
echo ""

TRIP_DATA='{
  "title": "Kyoto Cherry Blossoms",
  "destination": "Kyoto, Japan",
  "startDate": "2026-04-01",
  "endDate": "2026-04-05",
  "travelers": 2,
  "budget": 3000,
  "type": "travel",
  "description": "A beautiful 5-day trip to Kyoto"
}'

test_endpoint "2.1" "/trips" "POST" "$TRIP_DATA" "200" "POST /api/trips - Create trip"

# Extract trip ID
TRIP_RESPONSE=$(curl -s -X POST "${BASE_URL}/trips" \
    -H "Authorization: Bearer ${AUTH_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "$TRIP_DATA")

if echo "$TRIP_RESPONSE" | jq -e '.id' &>/dev/null 2>&1; then
    TRIP_ID=$(echo "$TRIP_RESPONSE" | jq -r '.id')
    echo "Extracted Trip ID: ${TRIP_ID}"
fi

# Test get trip
if [ -n "$TRIP_ID" ]; then
    test_endpoint "2.2" "/trips/${TRIP_ID}" "GET" "" "200" "GET /api/trips/:id - Verify trip created"
fi

echo ""

# STEP 3: Browse & Add Activities
echo -e "${YELLOW}========== STEP 3: Browse & Add Activities ==========${NC}"
echo ""

test_endpoint "3.1" "/discover?destination=Kyoto&q=temples" "GET" "" "200" "GET /api/discover - Search for temples in Kyoto"

test_endpoint "3.2" "/discover?destination=Kyoto&q=food%20tour" "GET" "" "200" "GET /api/discover - Search for food tours"

test_endpoint "3.3" "/discover?destination=Kyoto&q=bamboo%20grove" "GET" "" "200" "GET /api/discover - Search for bamboo grove"

echo ""

# STEP 4: Browse Experts & Message
echo -e "${YELLOW}========== STEP 4: Browse Experts & Message ==========${NC}"
echo ""

test_endpoint "4.1" "/experts" "GET" "" "200" "GET /api/experts - List all experts"

test_endpoint "4.2" "/experts?destination=Kyoto" "GET" "" "200" "GET /api/experts - Filter by destination"

echo ""

# STEP 5: AI Optimization
echo -e "${YELLOW}========== STEP 5: AI Optimization ==========${NC}"
echo ""

if [ -n "$TRIP_ID" ]; then
    test_endpoint "5.1" "/ai/generate-blueprint" "POST" \
        "{\"tripId\":\"${TRIP_ID}\"}" \
        "200" \
        "POST /api/ai/generate-blueprint - Trigger AI optimization"
fi

test_endpoint "5.2" "/generated-itineraries" "GET" "" "200" "GET /api/generated-itineraries - List variants"

echo ""

# STEP 6: Itinerary Comparison
echo -e "${YELLOW}========== STEP 6: Itinerary Comparison ==========${NC}"
echo ""

test_endpoint "6.1" "/itinerary-comparison" "GET" "" "200" "GET /api/itinerary-comparison - Retrieve comparison data"

test_endpoint "6.2" "/itinerary-variants" "GET" "" "200" "GET /api/itinerary-variants - List all variants"

echo ""

# STEP 7: Transport & Export
echo -e "${YELLOW}========== STEP 7: Transport & Export ==========${NC}"
echo ""

if [ -n "$TRIP_ID" ]; then
    test_endpoint "7.1" "/transport-legs/${TRIP_ID}" "GET" "" "200" "GET /api/transport-legs/:tripId - Get transport legs"
fi

test_endpoint "7.2" "/itineraries/export" "POST" \
    "{\"format\":\"kml\"}" \
    "200" \
    "POST /api/itineraries/:id/export - Export itinerary"

echo ""

# STEP 8: Booking & Checkout
echo -e "${YELLOW}========== STEP 8: Booking & Checkout ==========${NC}"
echo ""

test_endpoint "8.1" "/cart" "GET" "" "200" "GET /api/cart - Review cart items"

test_endpoint "8.2" "/bookings/process-cart" "POST" \
    "{\"paymentMethod\":\"stripe\"}" \
    "200" \
    "POST /api/bookings/process-cart - Initiate checkout"

echo ""

# STEP 9: Expert Dashboard
echo -e "${YELLOW}========== STEP 9: Expert Dashboard ==========${NC}"
echo ""

# Sign up expert
EXPERT_SIGNUP=$(curl -s -X POST "${BASE_URL}/auth/signup" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${EXPERT_EMAIL}\",\"password\":\"${EXPERT_PASSWORD}\",\"name\":\"Kyoto Expert\",\"role\":\"expert\"}")

if echo "$EXPERT_SIGNUP" | jq -e '.token' &>/dev/null 2>&1; then
    EXPERT_TOKEN=$(echo "$EXPERT_SIGNUP" | jq -r '.token')
    EXPERT_ID=$(echo "$EXPERT_SIGNUP" | jq -r '.id')
    echo "Expert signed up with Token: ${EXPERT_TOKEN:0:20}..."
fi

# Switch to expert role
test_endpoint "9.1" "/expert/dashboard" "GET" "" "200" "GET /api/expert/dashboard - Switch to expert role"

test_endpoint "9.2" "/expert/bookings" "GET" "" "200" "GET /api/expert/bookings - Check expert bookings"

test_endpoint "9.3" "/expert/messages" "GET" "" "200" "GET /api/expert/messages - Check expert messages"

echo ""

# STEP 10: Traveler Dashboard
echo -e "${YELLOW}========== STEP 10: Traveler Dashboard ==========${NC}"
echo ""

# Switch back to traveler
AUTH_TOKEN=""
TRAVELER_LOGIN=$(curl -s -X POST "${BASE_URL}/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${TEST_EMAIL}\",\"password\":\"${TEST_PASSWORD}\"}")

if echo "$TRAVELER_LOGIN" | jq -e '.token' &>/dev/null 2>&1; then
    AUTH_TOKEN=$(echo "$TRAVELER_LOGIN" | jq -r '.token')
    echo "Traveler logged in with Token: ${AUTH_TOKEN:0:20}..."
fi

test_endpoint "10.1" "/trips" "GET" "" "200" "GET /api/trips - List Maya's trips"

test_endpoint "10.2" "/bookings" "GET" "" "200" "GET /api/bookings - List Maya's bookings"

test_endpoint "10.3" "/notifications" "GET" "" "200" "GET /api/notifications - Check messages/notifications"

echo ""

# Error scenarios
echo -e "${YELLOW}========== ERROR SCENARIOS ==========${NC}"
echo ""

test_endpoint "E.1" "/trips" "POST" \
    "{\"title\":\"Bad Trip\",\"destination\":\"Nonexistent City\",\"startDate\":\"2026-04-01\",\"endDate\":\"2026-03-28\",\"travelers\":2,\"budget\":3000}" \
    "400" \
    "Invalid date range (end before start)"

test_endpoint "E.2" "/trips" "POST" \
    "{\"title\":\"No Destination\"}" \
    "400" \
    "Missing required fields"

test_endpoint "E.3" "/trips/invalid-id" "GET" "" "404" "Invalid trip ID"

echo ""

# SUMMARY
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}TEST SUMMARY${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "Total Steps Tested: $TOTAL_STEPS"
echo -e "${GREEN}Working: $WORKING_STEPS${NC}"
echo -e "${YELLOW}Partial: $PARTIAL_STEPS${NC}"
echo -e "${RED}Broken: $BROKEN_STEPS${NC}"
echo -e "${BLUE}Not Wired: $NOT_WIRED_STEPS${NC}"
echo ""

if [ $BROKEN_STEPS -eq 0 ] && [ $NOT_WIRED_STEPS -eq 0 ]; then
    echo -e "${GREEN}✅ All tests passed!${NC}"
else
    echo -e "${RED}❌ Some tests failed${NC}"
fi
