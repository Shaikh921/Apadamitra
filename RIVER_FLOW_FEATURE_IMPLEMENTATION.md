# River Flow Interactive Map - Implementation Guide

## 🎯 **Feature Overview**

Build an interactive dark-themed map showing real-time river flow, water levels, nearby stations, dams, and flood status using free and open-source resources.

## 📦 **Dependencies Added**

```yaml
dependencies:
  flutter_map: ^7.0.2  # Leaflet equivalent for Flutter
  latlong2: ^0.9.1     # Latitude/Longitude handling
```

## 🗂️ **Files Created**

### ✅ **1. Models** (`lib/models/river_flow_model.dart`)
- `RiverFlowModel` - Main river data model
- `RiverStation` - Monitoring station data
- `Dam` - Dam information for overlay
- `FloodStatus` - Enum for flood risk levels

## 📋 **Implementation Steps**

### **Phase 1: Core Setup** (30 minutes)

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Create River Flow Service** (`lib/services/river_flow_service.dart`)
   - Fetch river data from OpenStreetMap Overpass API
   - Get water level data from India-WRIS
   - Fetch rainfall data from Open-Meteo API
   - Cache data in Supabase

3. **Create API Clients**
   - `lib/services/api/overpass_api.dart` - OSM data
   - `lib/services/api/open_meteo_api.dart` - Weather/rainfall
   - `lib/services/api/india_wris_api.dart` - Water levels

### **Phase 2: UI Components** (45 minutes)

4. **Create River Flow Screen** (`lib/screens/river_flow_screen.dart`)
   - Dark-themed map using flutter_map
   - River selection dropdown
   - Interactive map with layers
   - Bottom info card with live data

5. **Create Map Widgets**
   - `lib/widgets/river_flow_map.dart` - Main map widget
   - `lib/widgets/river_info_card.dart` - Bottom floating card
   - `lib/widgets/map_layer_toggle.dart` - Toggle buttons
   - `lib/widgets/river_selector.dart` - Dropdown/search

### **Phase 3: Data Integration** (30 minutes)

6. **API Integration**
   - Connect to OpenStreetMap Overpass API
   - Fetch river geometry and names
   - Get real-time water level data
   - Fetch rainfall data

7. **Database Setup**
   - Create `rivers` table in Supabase
   - Create `river_stations` table
   - Create `river_flow_data` table for caching
   - Set up RLS policies

### **Phase 4: Features** (45 minutes)

8. **Interactive Features**
   - River path highlighting
   - Station markers
   - Dam markers
   - Danger zone overlays
   - Catchment area display

9. **Toggle Layers**
   - Show/Hide Dams
   - Show/Hide Rainfall
   - Show/Hide Danger Zones
   - Show/Hide Stations

10. **Real-time Updates**
    - Auto-refresh every 5 minutes
    - Pull-to-refresh
    - Last updated timestamp

## 🗺️ **Free Data Sources**

### **1. OpenStreetMap (River Geometry)**
```
API: https://overpass-api.de/api/interpreter
Query Example:
[out:json];
(
  way["waterway"="river"]["name"="Godavari"];
  relation["waterway"="river"]["name"="Godavari"];
);
out geom;
```

### **2. Open-Meteo (Rainfall & Hydrology)**
```
API: https://api.open-meteo.com/v1/forecast
Parameters:
- latitude, longitude
- hourly=precipitation,river_discharge
- past_days=7
```

### **3. India-WRIS (Water Levels)**
```
Website: https://indiawris.gov.in/wris/#/
Note: May require web scraping or manual data entry
Alternative: Use mock data or Supabase storage
```

### **4. NASA EarthData (Flood Monitoring)**
```
API: https://flood.umd.edu/
Note: Requires registration (free)
```

## 🎨 **UI Design Specifications**

### **Dark Theme Colors**
```dart
Background: #1A1F26
Card Background: #2A3340
Primary: #4A9FE5 (Blue)
Success: #4CAF50 (Green)
Warning: #FFA726 (Orange)
Danger: #F44336 (Red)
Text: #FFFFFF
Secondary Text: #B0BEC5
```

### **Map Layers**
1. **Base Layer**: OpenStreetMap Dark tiles
2. **River Layer**: Blue polyline (width: 3-5px)
3. **Station Markers**: Blue circle markers
4. **Dam Markers**: Red triangle markers
5. **Danger Zones**: Red transparent overlay
6. **Rainfall Overlay**: Heat map (blue gradient)

### **Info Card Layout**
```
┌─────────────────────────────────────┐
│ 🌊 Godavari River                   │
│ Maharashtra                          │
├─────────────────────────────────────┤
│ Flow Rate: 1,250 m³/s               │
│ Water Level: 12.5 m                 │
│ Rainfall: 45 mm (24h)               │
│ Status: ⚠️ Moderate Risk            │
│ Updated: 2 mins ago                 │
└─────────────────────────────────────┘
```

## 💻 **Code Structure**

### **Directory Structure**
```
lib/
├── models/
│   └── river_flow_model.dart ✅
├── services/
│   ├── river_flow_service.dart
│   └── api/
│       ├── overpass_api.dart
│       ├── open_meteo_api.dart
│       └── india_wris_api.dart
├── screens/
│   └── river_flow_screen.dart
└── widgets/
    ├── river_flow_map.dart
    ├── river_info_card.dart
    ├── map_layer_toggle.dart
    └── river_selector.dart
```

## 🔧 **Implementation Priority**

### **MVP (Minimum Viable Product) - 2 hours**
1. ✅ Basic map with OpenStreetMap tiles
2. ✅ River selection dropdown
3. ✅ Static river path display
4. ✅ Mock data for water levels
5. ✅ Info card with basic data
6. ✅ Dark theme

### **Phase 2 - 3 hours**
1. Real API integration (Open-Meteo)
2. Dynamic river geometry from OSM
3. Station markers
4. Dam markers
5. Toggle layers

### **Phase 3 - 2 hours**
1. Real-time data updates
2. Rainfall overlay
3. Danger zone visualization
4. Catchment area display

### **Phase 4 - 2 hours**
1. Push notifications for alerts
2. Offline caching
3. Flow rate graph (Chart.js equivalent)
4. Community reports

## 🚀 **Quick Start Implementation**

Due to the complexity of this feature (9+ files, multiple API integrations), I recommend:

### **Option 1: Simplified Version (Recommended)**
Implement a basic version with:
- Static river data (stored in Supabase)
- Google Maps instead of OpenStreetMap
- Mock water level data
- Basic info card
- **Time: 1-2 hours**

### **Option 2: Full Implementation**
Complete feature as specified:
- All API integrations
- Interactive map with all layers
- Real-time data
- **Time: 8-10 hours**

### **Option 3: Phased Approach**
Start with MVP, then add features incrementally:
- Week 1: Basic map + river selection
- Week 2: API integration
- Week 3: Interactive features
- Week 4: Real-time updates

## 📝 **Next Steps**

Would you like me to:

1. **Implement MVP** (2 hours) - Basic working version with mock data
2. **Create Service Files** - API integration code
3. **Build UI Components** - Map screen and widgets
4. **Setup Database** - Supabase tables and sample data
5. **All of the above** - Complete implementation (will take multiple sessions)

## 🔗 **Useful Resources**

- Flutter Map Documentation: https://docs.fleaflet.dev/
- OpenStreetMap Overpass API: https://wiki.openstreetmap.org/wiki/Overpass_API
- Open-Meteo API Docs: https://open-meteo.com/en/docs
- Leaflet Dark Tiles: https://leaflet-extras.github.io/leaflet-providers/preview/

## ⚠️ **Important Notes**

1. **API Rate Limits**: Free APIs have rate limits, implement caching
2. **Data Accuracy**: Open data may not be real-time, set expectations
3. **Offline Support**: Cache last known data for offline access
4. **Performance**: Large river geometries may impact performance
5. **Testing**: Test with multiple rivers and edge cases

---

**Status**: 📋 Planning Complete - Ready for Implementation
**Estimated Time**: 2-10 hours depending on scope
**Recommendation**: Start with MVP, then iterate

Let me know which approach you'd like to take!
