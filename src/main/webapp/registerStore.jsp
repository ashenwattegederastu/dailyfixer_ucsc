<%@ page contentType="text/html; charset=UTF-8" %>
    <%@ page import="java.util.*" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Register Store - DailyFixer</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            <style>
                .signup-wrapper {
                    display: flex;
                    justify-content: center;
                    padding: 60px 20px;
                }

                .card {
                    width: 1100px;
                    max-width: 1200px;
                    display: flex;
                    gap: 30px;
                }

                .left,
                .right {
                    background: #fff;
                    padding: 30px;
                    border-radius: 12px;
                    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
                }

                .left {
                    flex: 1;
                }

                .right {
                    width: 450px;
                }

                .section-title {
                    font-size: 18px;
                    margin-bottom: 12px;
                    font-weight: 600;
                }

                .input-row {
                    display: flex;
                    gap: 12px;
                }

                .input-row>div {
                    flex: 1;
                }

                .small {
                    width: 100%;
                    box-sizing: border-box;
                    padding: 10px;
                    border-radius: 8px;
                    border: 1px solid #ccc;
                }

                .error {
                    color: #b00020;
                    margin-bottom: 12px;
                }

                /* Map styles */
                #store-map {
                    width: 100%;
                    height: 280px;
                    border-radius: 10px;
                    margin-top: 12px;
                    border: 2px solid #e0e0e0;
                }

                .location-info {
                    background: #f5f5f5;
                    padding: 10px 14px;
                    border-radius: 8px;
                    margin-top: 10px;
                    font-size: 13px;
                }

                .location-info.success {
                    background: #e8f5e9;
                    color: #2e7d32;
                }

                .location-info.error {
                    background: #ffebee;
                    color: #c62828;
                }

                .location-coords {
                    font-weight: 600;
                }

                .map-instructions {
                    font-size: 12px;
                    color: #666;
                    margin-top: 8px;
                    padding: 8px;
                    background: #fff3e0;
                    border-radius: 6px;
                }

                .search-box-container {
                    margin-top: 12px;
                }

                .search-box-container label {
                    font-weight: 500;
                    margin-bottom: 4px;
                    display: block;
                }
            </style>
        </head>

        <body>

            <div class="signup-wrapper">
                <div class="card">
                    <div class="left">
                        <h2>Store Account</h2>

                        <c:if test="${not empty errorMsg}">
                            <div class="error">${errorMsg}</div>
                        </c:if>

                        <form id="registerForm" method="post" action="registerStore"
                            onsubmit="return submitForm(event);">
                            <!-- Hidden fields for coordinates -->
                            <input type="hidden" name="latitude" id="latitude">
                            <input type="hidden" name="longitude" id="longitude">

                            <!-- User fields -->
                            <div class="section-title">Owner details</div>
                            <div class="input-row">
                                <div>
                                    <label>First name</label>
                                    <input class="small" type="text" name="firstName" id="firstName" required>
                                </div>
                                <div>
                                    <label>Last name</label>
                                    <input class="small" type="text" name="lastName" id="lastName" required>
                                </div>
                            </div>

                            <div class="input-row" style="margin-top:12px;">
                                <div>
                                    <label>Username</label>
                                    <input class="small" type="text" name="username" id="username" required>
                                </div>
                                <div>
                                    <label>Password</label>
                                    <input class="small" type="password" name="password" id="password" required>
                                </div>
                            </div>

                            <div style="margin-top:12px;">
                                <label>Email</label>
                                <input class="small" type="email" name="email" id="email" required>
                            </div>

                            <div style="margin-top:12px;">
                                <label>Phone number</label>
                                <input class="small" type="text" name="phone" id="phone">
                            </div>

                            <div style="margin-top:12px;">
                                <label>Your City (optional)</label>
                                <select class="small" name="city">
                                    <option value="">-- Select city --</option>
                                    <% String[]
                                        cities={"Colombo","Kandy","Galle","Jaffna","Kurunegala","Matara","Trincomalee","Batticaloa","Negombo","Anuradhapura","Polonnaruwa","Badulla","Ratnapura","Puttalam","Kilinochchi","Mannar","Hambantota"};
                                        for (String c : cities) { %>
                                        <option value="<%=c%>">
                                            <%=c%>
                                        </option>
                                        <% } %>
                                </select>
                            </div>

                            <!-- Store fields -->
                            <div class="section-title" style="margin-top:18px;">Store details</div>

                            <div style="margin-top:6px;">
                                <label>Store name</label>
                                <input class="small" type="text" name="storeName" id="storeName" required>
                            </div>

                            <!-- Store address (Hidden, populated by map) -->
                            <input type="hidden" name="storeAddress" id="storeAddress">


                            <div class="input-row" style="margin-top:12px;">
                                <div>
                                    <label>Store city</label>
                                    <select class="small" name="storeCity" id="storeCity" required>
                                        <option value="">-- Select city --</option>
                                        <% for (String c : cities) { %>
                                            <option value="<%=c%>">
                                                <%=c%>
                                            </option>
                                            <% } %>
                                    </select>
                                </div>
                                <div>
                                    <label>Store type</label>
                                    <select class="small" name="storeType" id="storeType" required>
                                        <option value="">-- Select type --</option>
                                        <option value="electronics">Electronics</option>
                                        <option value="hardware">Hardware</option>
                                        <option value="vehicle repair">Vehicle Repair</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                            </div>

                            <div style="margin-top:18px;">
                                <button type="submit" class="login-btn" id="submitBtn">Register Store</button>
                            </div>
                        </form>
                    </div>

                    <div class="right">
                        <h3>📍 Store Location</h3>
                        <p style="font-size:13px;color:#666;">Set your store location using the search box or by
                            clicking on the map.</p>

                        <!-- Search Box for Places Autocomplete -->
                        <div class="search-box-container">
                            <label>Search for location:</label>
                            <input class="small" type="text" id="map-search-input"
                                placeholder="Type address or place name...">
                        </div>

                        <!-- Interactive Map -->
                        <div id="store-map"></div>

                        <div class="map-instructions">
                            <strong>💡 Tips:</strong><br>
                            • Type an address in the search box above, OR<br>
                            • Click directly on the map to pin your store location
                        </div>

                        <!-- Location Status -->
                        <div id="locationInfo" class="location-info">
                            Location not set. Please select your store location on the map.
                        </div>

                        <hr style="margin-top:20px;">

                        <p>Already have an account? <a href="login.jsp">Log in</a></p>
                        <p>Or go back <a href="index.jsp">Home</a></p>

                        <p style="font-size:12px;color:#888;margin-top:12px;">By registering you agree to our terms and
                            that information you provide is accurate.</p>
                    </div>
                </div>
            </div>

            <!-- Google Maps API with Places library -->
            <script
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8zSes6UGbYKIHNzCp3tny5RgccFruILI&libraries=places&callback=initMap"
                async defer></script>

            <script>
                var map;
                var marker;
                var geocoder;
                var autocomplete;
                var selectedLat = null;
                var selectedLng = null;

                // Initialize the map
                function initMap() {
                    // Default center: Sri Lanka
                    var sriLanka = { lat: 7.8731, lng: 80.7718 };

                    map = new google.maps.Map(document.getElementById('store-map'), {
                        center: sriLanka,
                        zoom: 8,
                        mapTypeControl: false,
                        streetViewControl: false,
                        fullscreenControl: true
                    });

                    geocoder = new google.maps.Geocoder();

                    // Create a draggable marker
                    marker = new google.maps.Marker({
                        map: map,
                        draggable: true,
                        visible: false,
                        animation: google.maps.Animation.DROP
                    });

                    // Click on map to set location
                    map.addListener('click', function (e) {
                        setLocation(e.latLng.lat(), e.latLng.lng());
                        reverseGeocode(e.latLng);
                    });

                    // Drag marker to set location
                    marker.addListener('dragend', function (e) {
                        setLocation(e.latLng.lat(), e.latLng.lng());
                        reverseGeocode(e.latLng);
                    });

                    // Initialize Places Autocomplete
                    var searchInput = document.getElementById('map-search-input');
                    autocomplete = new google.maps.places.Autocomplete(searchInput, {
                        componentRestrictions: { country: 'lk' }, // Restrict to Sri Lanka
                        fields: ['geometry', 'formatted_address', 'name']
                    });

                    autocomplete.addListener('place_changed', function () {
                        var place = autocomplete.getPlace();

                        if (place.geometry && place.geometry.location) {
                            var lat = place.geometry.location.lat();
                            var lng = place.geometry.location.lng();

                            setLocation(lat, lng);
                            map.setCenter(place.geometry.location);
                            map.setZoom(15);

                            updateLocationInfo(place.formatted_address || place.name, lat, lng);
                        } else {
                            showLocationError('Could not find that location. Please try again.');
                        }
                    });
                }

                // Set the location coordinates
                function setLocation(lat, lng) {
                    selectedLat = lat;
                    selectedLng = lng;

                    // Update hidden form fields
                    document.getElementById('latitude').value = lat;
                    document.getElementById('longitude').value = lng;

                    // Update marker position
                    var position = new google.maps.LatLng(lat, lng);
                    marker.setPosition(position);
                    marker.setVisible(true);
                }

                // Reverse geocode to get address from coordinates
                function reverseGeocode(latLng) {
                    geocoder.geocode({ location: latLng }, function (results, status) {
                        if (status === 'OK' && results[0]) {
                            updateLocationInfo(results[0].formatted_address, latLng.lat(), latLng.lng());
                        } else {
                            updateLocationInfo('Location selected', latLng.lat(), latLng.lng());
                        }
                    });
                }

                // Update the location info display
                function updateLocationInfo(address, lat, lng) {
                    var infoDiv = document.getElementById('locationInfo');
                    infoDiv.className = 'location-info success';
                    infoDiv.innerHTML = '<strong>✓ Location Set:</strong><br>' +
                        '<span style="font-size:12px;">' + address + '</span><br>' +
                        '<span class="location-coords">Lat: ' + lat.toFixed(6) + ', Lng: ' + lng.toFixed(6) + '</span>';

                    // Auto-fill the hidden store address field
                    document.getElementById('storeAddress').value = address;
                }

                // Show location error
                function showLocationError(message) {
                    var infoDiv = document.getElementById('locationInfo');
                    infoDiv.className = 'location-info error';
                    infoDiv.innerHTML = '<strong>⚠ Error:</strong> ' + message;
                }

                // Client-side validation
                function validateForm() {
                    var u = document.getElementById('username').value.trim();
                    var em = document.getElementById('email').value.trim();
                    var pw = document.getElementById('password').value;
                    var sn = document.getElementById('storeName').value.trim();
                    var lat = document.getElementById('latitude').value;
                    var lng = document.getElementById('longitude').value;
                    var sc = document.getElementById('storeCity').value;

                    var err = [];
                    if (!u) err.push("Username required");
                    if (!em) err.push("Email required");
                    if (!pw || pw.length < 6) err.push("Password required (min 6 chars)");
                    if (!sn) err.push("Store name required");
                    if (!lat || !lng || lat === '' || lng === '') err.push("Please select a store location on the map.");
                    if (!sc) err.push("Store city required");

                    if (err.length) {
                        alert(err.join("\n"));
                        return false;
                    }
                    return true;
                }

                // Submit form - geocode if no map selection, else use selected coords
                function submitForm(event) {
                    event.preventDefault();

                    if (!validateForm()) {
                        return false;
                    }

                    var submitBtn = document.getElementById('submitBtn');
                    submitBtn.disabled = true;
                    submitBtn.textContent = 'Registering...';

                    // Submit the form - validation already checked that location is set
                    document.getElementById('registerForm').submit();
                    return false;
                }
            </script>

        </body>

        </html>