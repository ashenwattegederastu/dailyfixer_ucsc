<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Create Booking - Daily Fixer</title>
            <jsp:include page="../shared/header.jsp" />
            <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8zSes6UGbYKIHNzCp3tny5RgccFruILI&libraries=places"></script>
        </head>

        <body>
            <div style="max-width: 800px; margin: 100px auto 2rem; padding: 0 1rem;">
                <h1 style="font-size: 2rem; font-weight: 700; margin-bottom: 1rem; color: var(--foreground);">Book
                    Service</h1>

                <c:if test="${not empty error}">
                    <div
                        style="background: var(--destructive); color: var(--destructive-foreground); padding: 1rem; border-radius: 0; margin-bottom: 1rem;">
                        ${error}
                    </div>
                </c:if>

                <div
                    style="background: var(--card); padding: 1.5rem; border-radius: 0; margin-bottom: 2rem; box-shadow: var(--shadow-sm);">
                    <div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 1rem; flex-wrap: wrap;">
                        <div>
                            <h2 style="font-size: 1.5rem; font-weight: 600; margin-bottom: 0.5rem;">${service.serviceName}</h2>
                            <p style="color: var(--muted-foreground); margin-bottom: 0.5rem;">${service.description}</p>
                            <p style="font-size: 1.25rem; font-weight: 700; color: var(--primary);">
                                <c:choose>
                                    <c:when test="${service.pricingType == 'fixed'}">LKR ${service.fixedRate}</c:when>
                                    <c:otherwise>LKR ${service.hourlyRate}/hr</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <button type="button" id="viewReviewsBtn"
                            onclick="openReviewsModal(${technicianId})"
                            style="background: var(--secondary); color: var(--secondary-foreground); padding: 0.5rem 1.2rem; border: 1px solid var(--border); border-radius: 0; font-weight: 600; cursor: pointer; font-size: 0.9rem; white-space: nowrap;">
                            ★ View Reviews
                        </button>
                    </div>
                </div>

                <c:if test="${not empty availability}">
                    <div style="background: var(--accent); padding: 1rem; border-radius: 0; margin-bottom: 1.5rem;">
                        <p style="font-weight: 600; margin-bottom: 0.5rem;">Technician Availability:</p>
                        <p>Available: ${availability.startTime} - ${availability.endTime}</p>
                        <p>Days:
                            <c:if test="${availability.monday}">Mon </c:if>
                            <c:if test="${availability.tuesday}">Tue </c:if>
                            <c:if test="${availability.wednesday}">Wed </c:if>
                            <c:if test="${availability.thursday}">Thu </c:if>
                            <c:if test="${availability.friday}">Fri </c:if>
                            <c:if test="${availability.saturday}">Sat </c:if>
                            <c:if test="${availability.sunday}">Sun</c:if>
                        </p>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/bookings/create">
                    <input type="hidden" name="serviceId" value="${service.serviceId}">
                    <input type="hidden" name="latitude" id="latitude">
                    <input type="hidden" name="longitude" id="longitude">
                    <input type="hidden" name="isRecurring" id="isRecurringInput" value="false">

                    <div
                        style="background: var(--card); padding: 1.5rem; border-radius: 0; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 1rem;">Booking Details</h3>

                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Booking Date
                                *</label>
                            <input type="date" name="bookingDate" required
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0; background: var(--input);">
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Booking Time
                                *</label>
                            <input type="time" name="bookingTime" required
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0; background: var(--input);">
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Phone Number
                                *</label>
                            <input type="tel" name="phoneNumber" required pattern="[0-9]{10}" placeholder="0771234567"
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0; background: var(--input);">
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Problem Description
                                *</label>
                            <textarea name="problemDescription" required rows="4"
                                placeholder="Describe your problem in detail..."
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0; background: var(--input); resize: vertical;"></textarea>
                        </div>

                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Location *</label>
                            <input type="text" id="locationSearch" placeholder="Search for your location..."
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0; background: var(--input); margin-bottom: 0.5rem;">
                            <div id="map"
                                style="width: 100%; height: 300px; border-radius: 0; border: 1px solid var(--border);">
                            </div>
                            <input type="text" name="locationAddress" id="locationAddress" required readonly
                                placeholder="Selected address will appear here"
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: 0; background: var(--input); margin-top: 0.5rem;">
                        </div>

                        <!-- Recurring Booking Option (only shown when service supports it) -->
                        <c:if test="${service.recurringEnabled}">
                        <div style="margin-bottom: 1rem; padding: 1rem; border: 1px solid #93c5fd; border-radius: 0; background: #eff6ff;">
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 0.5rem;">
                                <input type="checkbox" id="recurringCheckbox" onchange="toggleRecurringPanel()"
                                    style="width: 18px; height: 18px; cursor: pointer; accent-color: #1d4ed8;">
                                <label for="recurringCheckbox" style="font-weight: 600; color: #1e40af; cursor: pointer; margin: 0;">
                                    &#8635; Book as Recurring Service (Monthly, 1-Year Contract)
                                </label>
                            </div>
                            <div id="recurringInfoPanel" style="display: none; margin-top: 0.75rem;">
                                <div style="background: white; border: 1px solid #bfdbfe; border-radius: 0; padding: 1rem; margin-bottom: 0.5rem;">
                                    <p style="font-weight: 700; color: #1e40af; font-size: 1.05rem; margin: 0 0 0.5rem 0;">
                                        Monthly Recurring Fee: Rs. <fmt:formatNumber value="${service.recurringFee}" maxFractionDigits="2" minFractionDigits="2"/>
                                    </p>
                                    <ul style="margin: 0; padding-left: 1.25rem; color: #374151; font-size: 0.9rem; line-height: 1.7;">
                                        <li>This creates a <strong>1-year contract</strong> — the service is booked on the same day every month for 12 months.</li>
                                        <li>The date you choose below will repeat each month (day must be between 1st and 28th).</li>
                                        <li><strong>Payments are handled directly with the technician</strong> — not through DailyFixer.</li>
                                        <li>Either party can cancel the contract at any time; only future bookings are affected.</li>
                                    </ul>
                                </div>
                                <p style="font-size: 0.8rem; color: #6b7280; margin: 0;">
                                    By checking this box you agree to the 1-year recurring service contract terms as stated above.
                                </p>
                            </div>
                        </div>
                        </c:if>

                        <button type="submit"
                            style="width: 100%; background: var(--primary); color: var(--primary-foreground); padding: 0.75rem; border: none; border-radius: 0; font-weight: 600; font-size: 1rem; cursor: pointer;">
                            Submit Booking Request
                        </button>
                    </div>
                </form>
            </div>

            <script>
                function toggleRecurringPanel() {
                    var checked = document.getElementById('recurringCheckbox').checked;
                    document.getElementById('isRecurringInput').value = checked ? 'true' : 'false';
                    document.getElementById('recurringInfoPanel').style.display = checked ? 'block' : 'none';
                    if (checked) validateRecurringDay();
                }

                function validateRecurringDay() {
                    var checkbox = document.getElementById('recurringCheckbox');
                    if (!checkbox || !checkbox.checked) return;
                    var dateInput = document.querySelector('input[name="bookingDate"]');
                    if (dateInput && dateInput.value) {
                        var day = new Date(dateInput.value + 'T00:00:00').getDate();
                        var existing = document.getElementById('recurringDayWarning');
                        if (day > 28) {
                            if (!existing) {
                                var warn = document.createElement('p');
                                warn.id = 'recurringDayWarning';
                                warn.style.cssText = 'color:#dc2626;font-weight:600;font-size:0.85rem;margin-top:6px;';
                                warn.innerText = '\u26A0 Recurring bookings require a date between the 1st and 28th of the month.';
                                document.getElementById('recurringInfoPanel').appendChild(warn);
                            }
                        } else {
                            if (existing) existing.remove();
                        }
                    }
                }

                document.addEventListener('DOMContentLoaded', function() {
                    var dateInput = document.querySelector('input[name="bookingDate"]');
                    if (dateInput) dateInput.addEventListener('change', validateRecurringDay);
                });

                let map, marker, geocoder;

                function initMap() {
                    // Default to Colombo, Sri Lanka
                    const defaultLocation = { lat: 6.9271, lng: 79.8612 };

                    map = new google.maps.Map(document.getElementById('map'), {
                        center: defaultLocation,
                        zoom: 13
                    });

                    geocoder = new google.maps.Geocoder();

                    marker = new google.maps.Marker({
                        map: map,
                        draggable: true,
                        position: defaultLocation
                    });

                    // Add click listener to map
                    map.addListener('click', function (event) {
                        placeMarker(event.latLng);
                    });

                    // Add drag listener to marker
                    marker.addListener('dragend', function (event) {
                        updateAddress(event.latLng);
                    });

                    // Search box
                    const input = document.getElementById('locationSearch');
                    const searchBox = new google.maps.places.SearchBox(input);

                    searchBox.addListener('places_changed', function () {
                        const places = searchBox.getPlaces();
                        if (places.length === 0) return;

                        const place = places[0];
                        if (!place.geometry || !place.geometry.location) return;

                        map.setCenter(place.geometry.location);
                        placeMarker(place.geometry.location);
                    });
                }

                function placeMarker(location) {
                    marker.setPosition(location);
                    map.panTo(location);
                    updateAddress(location);
                }

                function updateAddress(location) {
                    document.getElementById('latitude').value = location.lat();
                    document.getElementById('longitude').value = location.lng();

                    geocoder.geocode({ location: location }, function (results, status) {
                        if (status === 'OK' && results[0]) {
                            document.getElementById('locationAddress').value = results[0].formatted_address;
                        }
                    });
                }

                // Initialize map when page loads
                window.addEventListener('load', initMap);
            </script>

            <!-- Reviews Modal -->
            <div id="reviewsModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.55); z-index:2000; align-items:center; justify-content:center;">
                <div style="background:var(--card); border-radius:0; max-width:560px; width:92%; max-height:80vh; overflow-y:auto; padding:2rem; position:relative; box-shadow:0 20px 60px rgba(0,0,0,0.3);">
                    <button onclick="closeReviewsModal()" style="position:absolute; top:1rem; right:1.2rem; background:none; border:none; font-size:1.5rem; cursor:pointer; color:var(--muted-foreground);">✕</button>
                    <h2 style="font-size:1.4rem; font-weight:700; margin-bottom:0.25rem;">Technician Reviews</h2>
                    <div id="reviewsSummary" style="margin-bottom:1.2rem; color:var(--muted-foreground); font-size:0.9rem;"></div>
                    <div id="reviewsList"></div>
                </div>
            </div>

            <script>
                function openReviewsModal(technicianId) {
                    var modal = document.getElementById('reviewsModal');
                    modal.style.display = 'flex';
                    document.getElementById('reviewsSummary').innerHTML = 'Loading…';
                    document.getElementById('reviewsList').innerHTML = '';

                    fetch('${pageContext.request.contextPath}/technician/reviews?technicianId=' + technicianId)
                        .then(function(r) { return r.json(); })
                        .then(function(data) {
                            // Summary line
                            if (data.totalRatings > 0) {
                                var stars = '';
                                for (var i = 1; i <= 5; i++) {
                                    stars += i <= Math.round(data.avgRating) ? '★' : '☆';
                                }
                                document.getElementById('reviewsSummary').innerHTML =
                                    '<span style="color:#f59e0b;font-size:1.1rem;">' + stars + '</span> ' +
                                    '<strong>' + parseFloat(data.avgRating).toFixed(1) + '</strong>' +
                                    ' &nbsp;·&nbsp; ' + data.totalRatings + ' rating' + (data.totalRatings !== 1 ? 's' : '');
                            } else {
                                document.getElementById('reviewsSummary').innerHTML = 'No ratings yet.';
                            }

                            // Reviews list
                            var list = document.getElementById('reviewsList');
                            if (!data.reviews || data.reviews.length === 0) {
                                list.innerHTML = '<p style="color:var(--muted-foreground); font-style:italic;">No written reviews yet.</p>';
                                return;
                            }
                            data.reviews.forEach(function(r) {
                                var stars = '';
                                for (var i = 1; i <= 5; i++) stars += i <= r.rating ? '★' : '☆';
                                var card = document.createElement('div');
                                card.style.cssText = 'border:1px solid var(--border); border-radius:0; padding:1rem; margin-bottom:0.75rem;';
                                card.innerHTML =
                                    '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:0.4rem;">' +
                                        '<strong style="font-size:0.95rem;">' + escapeHtml(r.raterName) + '</strong>' +
                                        '<span style="color:#f59e0b; font-size:0.95rem;">' + stars + '</span>' +
                                    '</div>' +
                                    '<p style="margin:0 0 0.3rem; color:var(--foreground);">' + escapeHtml(r.review) + '</p>' +
                                    '<small style="color:var(--muted-foreground);">' + r.date + '</small>';
                                list.appendChild(card);
                            });
                        })
                        .catch(function() {
                            document.getElementById('reviewsSummary').innerHTML = 'Could not load reviews.';
                        });
                }

                function closeReviewsModal() {
                    document.getElementById('reviewsModal').style.display = 'none';
                }

                function escapeHtml(text) {
                    var d = document.createElement('div');
                    d.appendChild(document.createTextNode(text || ''));
                    return d.innerHTML;
                }

                // Close on backdrop click
                document.getElementById('reviewsModal').addEventListener('click', function(e) {
                    if (e.target === this) closeReviewsModal();
                });
            </script>
        </body>

        </html>