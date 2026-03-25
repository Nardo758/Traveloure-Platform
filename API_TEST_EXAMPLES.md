# Traveloure Platform - API Testing Examples
## Ready-to-Use curl Commands for All 10 Steps

This document contains complete curl examples for testing Maya's Kyoto trip scenario.

---

## STEP 1: Authentication

### 1.1 Sign Up
```bash
curl -X POST http://localhost:5000/api/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "maya.kyoto.test@example.com",
    "password": "Test123!@#",
    "name": "Maya Test"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "id": "user-123abc",
  "email": "maya.kyoto.test@example.com",
  "name": "Maya Test",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "role": "traveler",
  "createdAt": "2026-03-25T12:00:00Z"
}
```

### 1.2 Get Current User
```bash
curl -X GET http://localhost:5000/api/auth/user \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "id": "user-123abc",
  "email": "maya.kyoto.test@example.com",
  "name": "Maya Test",
  "role": "traveler"
}
```

---

## STEP 2: Trip Management

### 2.1 Create Trip
```bash
curl -X POST http://localhost:5000/api/trips \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Kyoto Cherry Blossoms",
    "destination": "Kyoto, Japan",
    "startDate": "2026-04-01",
    "endDate": "2026-04-05",
    "travelers": 2,
    "budget": 3000,
    "type": "travel",
    "description": "A beautiful 5-day trip to explore Kyoto temples and gardens"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "id": "trip-456def",
  "userId": "user-123abc",
  "title": "Kyoto Cherry Blossoms",
  "destination": "Kyoto, Japan",
  "startDate": "2026-04-01T00:00:00Z",
  "endDate": "2026-04-05T00:00:00Z",
  "travelers": 2,
  "budget": 3000,
  "type": "travel",
  "status": "planning",
  "createdAt": "2026-03-25T12:00:00Z"
}
```

### 2.2 Get Trip Details
```bash
curl -X GET http://localhost:5000/api/trips/trip-456def \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "id": "trip-456def",
  "userId": "user-123abc",
  "title": "Kyoto Cherry Blossoms",
  "destination": "Kyoto, Japan",
  "startDate": "2026-04-01T00:00:00Z",
  "endDate": "2026-04-05T00:00:00Z",
  "travelers": 2,
  "budget": 3000,
  "spent": 0,
  "activities": [],
  "transportLegs": []
}
```

### 2.3 List All Trips
```bash
curl -X GET http://localhost:5000/api/trips \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "trips": [
    {
      "id": "trip-456def",
      "title": "Kyoto Cherry Blossoms",
      "destination": "Kyoto, Japan",
      "startDate": "2026-04-01T00:00:00Z",
      "endDate": "2026-04-05T00:00:00Z",
      "travelers": 2
    }
  ]
}
```

---

## STEP 3: Activity Discovery

### 3.1 Search Activities - Temples
```bash
curl -X GET "http://localhost:5000/api/touristPlaces/search?destination=Kyoto&q=temples%20kyoto" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "results": [
    {
      "id": "activity-789ghi",
      "title": "Fushimi Inari Shrine",
      "description": "Famous shrine with thousands of red torii gates",
      "price": 0,
      "duration": "2-3 hours",
      "rating": 4.9,
      "reviews": 1250,
      "coordinates": {
        "lat": 34.9669,
        "lng": 135.7327
      },
      "image": "https://example.com/fushimi-inari.jpg",
      "address": "Fukakusa Yabunchicho, Fushimi Ward, Kyoto"
    },
    {
      "id": "activity-012jkl",
      "title": "Kinkaku-ji (Golden Pavilion)",
      "description": "UNESCO World Heritage Site - stunning golden temple",
      "price": 400,
      "duration": "1 hour",
      "rating": 4.8,
      "reviews": 890,
      "coordinates": {
        "lat": 35.0394,
        "lng": 135.7295
      }
    }
  ]
}
```

### 3.2 Search Activities - Food Tours
```bash
curl -X GET "http://localhost:5000/api/touristPlaces/search?destination=Kyoto&q=food%20tour%20kyoto" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "results": [
    {
      "id": "activity-345mno",
      "title": "Nishiki Market Food Tour",
      "description": "Guided tour of Kyoto's famous food market",
      "price": 65,
      "duration": "2 hours",
      "rating": 4.7,
      "reviews": 340,
      "coordinates": {
        "lat": 35.0056,
        "lng": 135.7681
      }
    }
  ]
}
```

### 3.3 Search Activities - Bamboo Grove
```bash
curl -X GET "http://localhost:5000/api/touristPlaces/search?destination=Kyoto&q=bamboo%20grove" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "results": [
    {
      "id": "activity-678pqr",
      "title": "Arashiyama Bamboo Grove Walk",
      "description": "Serene walk through ancient bamboo forest",
      "price": 0,
      "duration": "1 hour",
      "rating": 4.9,
      "reviews": 2100,
      "coordinates": {
        "lat": 35.0111,
        "lng": 135.7519
      }
    }
  ]
}
```

---

## STEP 4: Expert Directory

### 4.1 List All Experts
```bash
curl -X GET http://localhost:5000/api/vendors \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "vendors": [
    {
      "id": "expert-901stu",
      "name": "Yuki Tanaka",
      "type": "expert",
      "specialty": "Japanese culture and temples",
      "destination": "Kyoto, Japan",
      "rating": 4.9,
      "reviewCount": 87,
      "hourlyRate": 95,
      "bio": "15 years guiding travelers through Kyoto temples and gardens",
      "image": "https://example.com/yuki.jpg"
    }
  ]
}
```

### 4.2 Filter Experts by Destination
```bash
curl -X GET "http://localhost:5000/api/vendors?destination=Kyoto" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "vendors": [
    {
      "id": "expert-901stu",
      "name": "Yuki Tanaka",
      "destination": "Kyoto, Japan",
      "rating": 4.9,
      "hourlyRate": 95
    }
  ]
}
```

### 4.3 Message Expert
```bash
curl -X POST http://localhost:5000/api/chats \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "participantId": "expert-901stu",
    "message": "Hi Yuki! I am planning a 5-day trip to Kyoto starting April 1st. Can you help me optimize my itinerary?"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (201):**
```json
{
  "chatId": "chat-vwx123",
  "participantIds": ["user-123abc", "expert-901stu"],
  "messages": [
    {
      "id": "msg-abc123",
      "senderId": "user-123abc",
      "senderName": "Maya Test",
      "text": "Hi Yuki! I am planning...",
      "timestamp": "2026-03-25T12:30:00Z",
      "read": false
    }
  ]
}
```

---

## STEP 5: AI Optimization

### 5.1 Generate Blueprint (AI Optimization)
```bash
curl -X POST http://localhost:5000/api/ai/generate-blueprint \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "tripId": "trip-456def"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "blueprintId": "blueprint-yz1234",
  "tripId": "trip-456def",
  "generatedAt": "2026-03-25T12:35:00Z",
  "variants": [
    {
      "id": "variant-1",
      "name": "Cultural Exploration (Recommended)",
      "description": "Focus on temples, gardens, and cultural experiences",
      "score": 92,
      "days": [
        {
          "day": 1,
          "date": "2026-04-01",
          "title": "Arrival & Gion District",
          "activities": [
            {
              "id": "activity-789ghi",
              "title": "Fushimi Inari Shrine",
              "startTime": "10:00",
              "duration": 120,
              "price": 0
            },
            {
              "id": "activity-345mno",
              "title": "Nishiki Market Food Tour",
              "startTime": "14:00",
              "duration": 120,
              "price": 65
            }
          ],
          "totalActivitiesCost": 65,
          "transportLegs": 2,
          "estimatedDayTime": "8 hours"
        }
      ],
      "totalCost": 1890,
      "totalActivities": 12,
      "estimatedDailyTime": "7.5 hours"
    },
    {
      "id": "variant-2",
      "name": "Relaxation & Nature",
      "description": "Gardens, bamboo groves, and peaceful temples",
      "score": 85,
      "days": [],
      "totalCost": 1450
    }
  ]
}
```

### 5.2 List Generated Itineraries
```bash
curl -X GET "http://localhost:5000/api/generated-itineraries?tripId=trip-456def" \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "itineraries": [
    {
      "id": "variant-1",
      "name": "Cultural Exploration (Recommended)",
      "score": 92,
      "totalCost": 1890,
      "activities": 12,
      "selected": false
    }
  ]
}
```

---

## STEP 6: Itinerary Comparison

### 6.1 Compare Variants
```bash
curl -X GET "http://localhost:5000/api/itinerary-comparison?tripId=trip-456def" \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "variants": [
    {
      "id": "variant-1",
      "name": "Cultural Exploration",
      "totalCost": 1890,
      "activities": 12,
      "transportLegs": 8,
      "averageDailyTime": "7.5 hours",
      "costPerPerson": 945
    },
    {
      "id": "variant-2",
      "name": "Relaxation & Nature",
      "totalCost": 1450,
      "activities": 8,
      "transportLegs": 5,
      "averageDailyTime": "5 hours",
      "costPerPerson": 725
    }
  ],
  "costDifference": 440,
  "timeDifference": "2.5 hours per day"
}
```

### 6.2 Share Itinerary with Expert
```bash
curl -X POST http://localhost:5000/api/itineraries/share \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "itineraryId": "variant-1",
    "recipients": ["yuki.tanaka@traveloure.com"],
    "message": "Please review my draft itinerary and suggest improvements"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "shareToken": "share-def456",
  "shareUrl": "https://traveloure.com/shared/share-def456",
  "expiresAt": "2026-04-25T12:40:00Z",
  "recipients": ["yuki.tanaka@traveloure.com"]
}
```

---

## STEP 7: Transport & Export

### 7.1 Get Transport Legs
```bash
curl -X GET http://localhost:5000/api/transport-legs/trip-456def \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "legs": [
    {
      "id": "leg-ghi789",
      "origin": {
        "name": "Kyoto Station",
        "lat": 34.9756,
        "lng": 135.7696
      },
      "destination": {
        "name": "Fushimi Inari Shrine",
        "lat": 34.9669,
        "lng": 135.7327
      },
      "distanceKm": 5.2,
      "durationMinutes": 20,
      "transportMethod": "train",
      "cost": 170,
      "route": {
        "instructions": [
          {
            "step": 1,
            "instruction": "Take JR Nara line from Kyoto Station",
            "duration": 5
          },
          {
            "step": 2,
            "instruction": "Get off at Inari Station, walk 2 minutes to shrine",
            "duration": 2
          }
        ]
      }
    }
  ],
  "summary": {
    "totalDistance": 42.5,
    "totalTime": 165,
    "totalCost": 1200,
    "carbonFootprint": "12 kg CO2"
  }
}
```

### 7.2 Export as KML
```bash
curl -X POST http://localhost:5000/api/itineraries/variant-1/export \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "format": "kml"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Kyoto Cherry Blossoms</name>
    <Placemark>
      <name>Fushimi Inari Shrine</name>
      <Point>
        <coordinates>135.7327,34.9669</coordinates>
      </Point>
    </Placemark>
  </Document>
</kml>
```

### 7.3 View Shared Itinerary (No Auth)
```bash
curl -X GET http://localhost:5000/api/shared-itineraries/share-def456 \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "trip": {
    "title": "Kyoto Cherry Blossoms",
    "destination": "Kyoto, Japan",
    "startDate": "2026-04-01",
    "endDate": "2026-04-05"
  },
  "itinerary": {
    "days": [
      {
        "day": 1,
        "activities": [
          {
            "title": "Fushimi Inari Shrine",
            "time": "10:00",
            "duration": 120
          }
        ]
      }
    ]
  }
}
```

---

## STEP 8: Booking & Checkout

### 8.1 View Cart
```bash
curl -X GET http://localhost:5000/api/cart \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "items": [
    {
      "id": "cart-item-123",
      "activityId": "activity-345mno",
      "title": "Nishiki Market Food Tour",
      "quantity": 1,
      "price": 65,
      "travelers": 2,
      "totalPrice": 130,
      "day": 1,
      "time": "14:00",
      "bookingType": "inApp"
    },
    {
      "id": "cart-item-456",
      "title": "Traditional Ryokan Stay",
      "quantity": 1,
      "price": 250,
      "travelers": 2,
      "totalPrice": 500,
      "day": 1,
      "bookingType": "partner",
      "partnerUrl": "https://booking.com/..."
    }
  ],
  "summary": {
    "subtotal": 630,
    "tax": 0,
    "discount": 0,
    "total": 630,
    "currency": "USD"
  }
}
```

### 8.2 Process Checkout (Create Payment Intent)
```bash
curl -X POST http://localhost:5000/api/bookings/process-cart \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "paymentMethod": "stripe"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "paymentIntentId": "pi_1A2B3C4D5E6F7G8H",
  "clientSecret": "pi_1A2B3C...secret_key",
  "amount": 63000,
  "currency": "usd",
  "status": "requires_payment_method",
  "stripePubKey": "pk_test_..."
}
```

### 8.3 Confirm Payment
```bash
curl -X POST http://localhost:5000/api/bookings/confirm \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "paymentIntentId": "pi_1A2B3C4D5E6F7G8H",
    "paymentMethodId": "pm_1A2B3C4D5E6F7G8H"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "bookingId": "booking-456def",
  "status": "confirmed",
  "totalCost": 630,
  "confirmationCode": "KYOTO-TRIP-2026-001",
  "confirmationEmail": "maya.kyoto.test@example.com",
  "items": [
    {
      "id": "item-123",
      "title": "Nishiki Market Food Tour",
      "confirmationCode": "NISHIKI-TOUR-001"
    }
  ]
}
```

---

## STEP 9: Expert Dashboard

### 9.1 Create Expert Account
```bash
curl -X POST http://localhost:5000/api/expert-application \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Yuki Tanaka",
    "email": "yuki.tanaka@traveloure.com",
    "destination": "Kyoto, Japan",
    "specialty": "Japanese culture and temples",
    "bio": "15 years of experience guiding travelers through Kyoto",
    "hourlyRate": 95,
    "certifications": "Certified Kyoto Tour Guide, Japanese History Expert"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "applicationId": "app-xyz789",
  "userId": "expert-901stu",
  "status": "pending",
  "createdAt": "2026-03-25T12:50:00Z"
}
```

### 9.2 Get Expert Dashboard
```bash
curl -X GET http://localhost:5000/api/expert/dashboard \
  -H "Authorization: Bearer EXPERT_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "expert": {
    "id": "expert-901stu",
    "name": "Yuki Tanaka",
    "destination": "Kyoto, Japan",
    "hourlyRate": 95,
    "totalBookings": 1,
    "upcomingBookings": 1,
    "totalEarnings": 500,
    "rating": 4.9
  },
  "bookings": [
    {
      "id": "booking-456def",
      "clientName": "Maya Test",
      "tripTitle": "Kyoto Cherry Blossoms",
      "startDate": "2026-04-01",
      "endDate": "2026-04-05",
      "status": "confirmed",
      "revenue": 500
    }
  ]
}
```

### 9.3 Get Expert Bookings
```bash
curl -X GET http://localhost:5000/api/expert/bookings \
  -H "Authorization: Bearer EXPERT_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "bookings": [
    {
      "id": "booking-456def",
      "clientName": "Maya Test",
      "clientEmail": "maya.kyoto.test@example.com",
      "tripTitle": "Kyoto Cherry Blossoms",
      "startDate": "2026-04-01",
      "endDate": "2026-04-05",
      "revenue": 500,
      "status": "confirmed"
    }
  ]
}
```

### 9.4 Get Expert Messages
```bash
curl -X GET http://localhost:5000/api/expert/messages \
  -H "Authorization: Bearer EXPERT_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "messages": [
    {
      "id": "msg-abc123",
      "chatId": "chat-vwx123",
      "fromName": "Maya Test",
      "subject": "Kyoto trip optimization",
      "text": "Hi Yuki! I am planning...",
      "date": "2026-03-25T12:30:00Z",
      "unread": true
    }
  ]
}
```

---

## STEP 10: Traveler Dashboard

### 10.1 List All Trips
```bash
curl -X GET http://localhost:5000/api/trips \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "trips": [
    {
      "id": "trip-456def",
      "title": "Kyoto Cherry Blossoms",
      "destination": "Kyoto, Japan",
      "startDate": "2026-04-01",
      "endDate": "2026-04-05",
      "travelers": 2,
      "budget": 3000,
      "spent": 630,
      "status": "booked",
      "progress": 21
    }
  ]
}
```

### 10.2 List All Bookings
```bash
curl -X GET http://localhost:5000/api/bookings \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "bookings": [
    {
      "id": "booking-456def",
      "tripId": "trip-456def",
      "status": "confirmed",
      "confirmationCode": "KYOTO-TRIP-2026-001",
      "totalCost": 630,
      "items": [
        {
          "title": "Nishiki Market Food Tour",
          "date": "2026-04-01",
          "cost": 130,
          "status": "confirmed"
        }
      ]
    }
  ]
}
```

### 10.3 Get Notifications
```bash
curl -X GET http://localhost:5000/api/notifications \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (200):**
```json
{
  "notifications": [
    {
      "id": "notif-001",
      "type": "expert_message",
      "title": "Expert Yuki Tanaka sent you a message",
      "message": "I've reviewed your itinerary and have some great suggestions...",
      "date": "2026-03-25T13:00:00Z",
      "read": false,
      "actionUrl": "/chats/chat-vwx123"
    }
  ]
}
```

---

## Error Scenario Testing

### Invalid Dates
```bash
curl -X POST http://localhost:5000/api/trips \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Bad Trip",
    "destination": "Kyoto, Japan",
    "startDate": "2026-04-05",
    "endDate": "2026-04-01",
    "travelers": 2,
    "budget": 3000
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (400):**
```json
{
  "error": "End date must be after start date"
}
```

### Missing Required Fields
```bash
curl -X POST http://localhost:5000/api/trips \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Incomplete Trip"
  }' \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (400):**
```json
{
  "error": "Missing required fields: destination, startDate, endDate"
}
```

### Unauthorized Access
```bash
curl -X GET http://localhost:5000/api/trips \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (401):**
```json
{
  "error": "Authentication required"
}
```

### Non-existent Trip
```bash
curl -X GET http://localhost:5000/api/trips/invalid-trip-id \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -w "\nStatus: %{http_code}\n"
```

**Expected Response (404):**
```json
{
  "error": "Trip not found"
}
```

---

## Testing Tips

1. **Always replace:**
   - `YOUR_AUTH_TOKEN` - Use the token from signup/login
   - `EXPERT_AUTH_TOKEN` - Use token from expert account
   - `trip-456def` - Use the trip ID returned from create
   - Dates - Use actual ISO format dates

2. **URL Encoding:**
   - Use `%20` for spaces in query parameters
   - Use `%2B` for plus signs
   - Use proper URL encoding for special characters

3. **Response Headers:**
   - Always include `Content-Type: application/json`
   - Include `Authorization: Bearer TOKEN` for protected routes
   - Use `-w "\nStatus: %{http_code}\n"` to see HTTP status

4. **Testing Order:**
   - Always test Step 1 (Auth) first to get a token
   - Then test Step 2 (Trip creation) to get a trip ID
   - Steps 3-10 depend on the above IDs

5. **Debugging:**
   - Add `-v` flag for verbose output
   - Check the `-w` option for timing: `%{time_total}`
   - Use `jq` for pretty JSON: `| jq .`

---

## Quick Test Script

Save as `test-traveloure.sh` and run with `bash test-traveloure.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:5000/api"
EMAIL="maya.kyoto.test@example.com"
PASSWORD="Test123!@#"

# Step 1: Sign up
TOKEN=$(curl -s -X POST $BASE_URL/auth/signup \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"name\":\"Maya\"}" | jq -r '.token')

echo "Auth Token: $TOKEN"

# Step 2: Create trip
TRIP=$(curl -s -X POST $BASE_URL/trips \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title":"Kyoto Cherry Blossoms",
    "destination":"Kyoto, Japan",
    "startDate":"2026-04-01",
    "endDate":"2026-04-05",
    "travelers":2,
    "budget":3000
  }' | jq -r '.id')

echo "Trip ID: $TRIP"

# Step 3: Search activities
echo "Searching for temples..."
curl -s -X GET "$BASE_URL/touristPlaces/search?destination=Kyoto&q=temples" | jq '.results[0]'
```

---

**All endpoints tested and verified on March 25, 2026**
