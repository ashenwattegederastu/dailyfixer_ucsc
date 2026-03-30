<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.dailyfixer.model.User" %>

<%
  User user = (User) session.getAttribute("currentUser");
  if (user == null || user.getRole() == null || !"driver".equalsIgnoreCase(user.getRole().trim())) {
    response.sendRedirect(request.getContextPath() + "/pages/shared/login.jsp");
    return;
  }
  Double savedLat = user.getLatitude();
  Double savedLng = user.getLongitude();
  boolean hasLocation = savedLat != null && savedLng != null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile | Daily Fixer</title>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
<style>
.container {
    flex: 1;
    margin-left: 240px;
    margin-top: 83px;
    padding: 30px;
    background-color: var(--background);
}
.container h2 {
    font-size: 1.6em;
    margin-bottom: 20px;
    color: var(--foreground);
}

/* Profile Card */
.profile-card {
    background: var(--card);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--border);
    overflow: hidden;
    margin-bottom: 20px;
}
.profile-image {
    background: var(--muted);
    padding: 30px;
    text-align: center;
    border-bottom: 1px solid var(--border);
}
.profile-image img {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid var(--primary);
    margin-bottom: 15px;
}
.profile-image h2 {
    font-size: 1.4em;
    margin-bottom: 5px;
    color: var(--foreground);
}
.profile-image .role {
    color: var(--primary);
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.9em;
}

/* Profile Details */
.profile-details {
    padding: 30px;
}
.profile-details table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 25px;
}
.profile-details th, .profile-details td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid var(--border);
}
.profile-details th {
    background: var(--muted);
    font-weight: 600;
    color: var(--foreground);
    width: 30%;
}
.profile-details td {
    color: var(--muted-foreground);
    font-weight: 500;
}

/* Profile Buttons */
.profile-buttons {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}
.profile-buttons .btn {
    padding: 12px 24px;
    border: none;
    border-radius: var(--radius-md);
    cursor: pointer;
    font-weight: 600;
    font-size: 0.9rem;
    text-decoration: none;
    display: inline-block;
    transition: all 0.2s;
    box-shadow: var(--shadow-sm);
}
.profile-buttons .btn.reset {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: #fff;
}
.profile-buttons .btn.edit {
    background: var(--primary);
    color: var(--primary-foreground);
}
.profile-buttons .btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}

/* Location Card */
.location-card {
    background: var(--card);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--border);
    overflow: hidden;
    margin-top: 20px;
}
.location-card .location-header {
    background: var(--muted);
    padding: 20px 30px;
    border-bottom: 1px solid var(--border);
}
.location-card .location-header h3 {
    font-size: 1.1em;
    font-weight: 700;
    color: var(--foreground);
    margin-bottom: 4px;
}
.location-card .location-header p {
    font-size: 0.85em;
    color: var(--muted-foreground);
}
.location-card .location-body {
    padding: 24px 30px;
}
.location-card .current-coords {
    display: flex;
    gap: 20px;
    margin-bottom: 16px;
    font-size: 0.9em;
    color: var(--muted-foreground);
}
.location-card .current-coords span {
    background: var(--muted);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 6px 12px;
    font-family: 'IBM Plex Mono', monospace;
}
#locationMap {
    width: 100%;
    height: 320px;
    border-radius: var(--radius-md);
    border: 1px solid var(--border);
    margin-bottom: 16px;
}
.location-card .location-instructions {
    font-size: 0.85em;
    color: var(--muted-foreground);
    margin-bottom: 14px;
}
.location-card .save-location-btn {
    padding: 11px 28px;
    background: var(--primary);
    color: var(--primary-foreground);
    border: none;
    border-radius: var(--radius-md);
    font-weight: 600;
    font-size: 0.9rem;
    cursor: pointer;
    box-shadow: var(--shadow-sm);
    transition: all 0.2s;
}
.location-card .save-location-btn:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-md);
    opacity: 0.9;
}
.location-card .save-location-btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
}
#locationStatus {
    margin-top: 10px;
    font-size: 0.9em;
    font-weight: 600;
}
#locationStatus.success { color: #28a745; }
#locationStatus.error   { color: #dc3545; }
.no-location-warning {
    margin-bottom: 14px;
    font-size: 0.9em;
    color: #c0392b;
    font-weight: 600;
}
</style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<main class="container">
    <h2>My Profile</h2>

    <div class="profile-card">
        <div class="profile-image">
            <img src="${pageContext.request.contextPath}/assets/images/default-profile.png" alt="Profile Picture">
            <h2>${sessionScope.currentUser.firstName} ${sessionScope.currentUser.lastName}</h2>
            <p class="role">(${sessionScope.currentUser.role})</p>
        </div>

        <div class="profile-details">
            <table>
                <tr><th>Driver ID:</th><td>${sessionScope.currentUser.userId}</td></tr>
                <tr><th>First Name:</th><td>${sessionScope.currentUser.firstName}</td></tr>
                <tr><th>Last Name:</th><td>${sessionScope.currentUser.lastName}</td></tr>
                <tr><th>Username:</th><td>${sessionScope.currentUser.username}</td></tr>
                <tr><th>Email:</th><td>${sessionScope.currentUser.email}</td></tr>
                <tr><th>Phone:</th><td>${sessionScope.currentUser.phoneNumber}</td></tr>
                <tr><th>City:</th><td>${sessionScope.currentUser.city}</td></tr>
                <tr><th>Role:</th><td>${sessionScope.currentUser.role}</td></tr>
            </table>

            <div class="profile-buttons">
                <form action="${pageContext.request.contextPath}/resetPassword.jsp" method="get">
                    <button type="submit" class="btn reset">Reset Password</button>
                </form>
                <form action="${pageContext.request.contextPath}/editProfile.jsp" method="get">
                    <button type="submit" class="btn edit">Edit Account Info</button>
                </form>
            </div>
        </div>
    </div>

    <!-- Home Base Location Card -->
    <div class="location-card">
        <div class="location-header">
            <h3>Home Base Location</h3>
            <p>Your home location is used to find nearby delivery requests within 10 km.</p>
        </div>
        <div class="location-body">
            <% if (hasLocation) { %>
            <div class="current-coords">
                <span id="coordLat">Lat: <%= String.format("%.7f", savedLat) %></span>
                <span id="coordLng">Lng: <%= String.format("%.7f", savedLng) %></span>
            </div>
            <% } else { %>
            <p class="no-location-warning">
                No location set. Please pin your home base to receive delivery requests.
            </p>
            <div class="current-coords" style="display: none;">
                <span id="coordLat">Lat: —</span>
                <span id="coordLng">Lng: —</span>
            </div>
            <% } %>

            <p class="location-instructions">Click anywhere on the map to pin your home base, then click Save.</p>
            <div id="locationMap"></div>

            <button class="save-location-btn" id="saveLocationBtn" onclick="saveLocation()" disabled>
                Save Location
            </button>
            <p id="locationStatus"></p>
        </div>
    </div>
</main>

<script>
    const CONTEXT_PATH = '<%= request.getContextPath() %>';
    const HAS_SAVED_LOC = <%= hasLocation %>;
    const SAVED_LAT = <%= hasLocation ? savedLat : "6.9271" %>;
    const SAVED_LNG = <%= hasLocation ? savedLng : "79.8612" %>;

    let map, marker;
    let pendingLat = null, pendingLng = null;

    function initDriverProfileMap() {
        const center = { lat: SAVED_LAT, lng: SAVED_LNG };

        map = new google.maps.Map(document.getElementById('locationMap'), {
            center: center,
            zoom: HAS_SAVED_LOC ? 14 : 12,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false
        });

        if (HAS_SAVED_LOC) {
            marker = new google.maps.Marker({
                position: center,
                map: map,
                title: 'Home Base',
                animation: google.maps.Animation.DROP
            });
        }

        map.addListener('click', function(e) {
            pendingLat = e.latLng.lat();
            pendingLng = e.latLng.lng();

            if (marker) {
                marker.setPosition(e.latLng);
            } else {
                marker = new google.maps.Marker({
                    position: e.latLng,
                    map: map,
                    title: 'Home Base',
                    animation: google.maps.Animation.DROP
                });
            }

            const coordsRow = document.querySelector('.current-coords');
            coordsRow.style.display = 'flex';
            document.getElementById('coordLat').textContent = 'Lat: ' + pendingLat.toFixed(7);
            document.getElementById('coordLng').textContent = 'Lng: ' + pendingLng.toFixed(7);

            document.getElementById('saveLocationBtn').disabled = false;
            document.getElementById('locationStatus').textContent = '';
        });
    }

    function saveLocation() {
        if (pendingLat === null || pendingLng === null) return;

        const btn = document.getElementById('saveLocationBtn');
        const status = document.getElementById('locationStatus');
        btn.disabled = true;
        btn.textContent = 'Saving...';
        status.textContent = '';
        status.className = '';

        fetch(CONTEXT_PATH + '/driver/updateLocation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'latitude=' + pendingLat + '&longitude=' + pendingLng
        })
        .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
        .then(data => {
            if (data.success) {
                status.textContent = 'Location saved successfully!';
                status.className = 'success';
                pendingLat = null;
                pendingLng = null;
            } else {
                status.textContent = 'Failed to save: ' + (data.message || 'Unknown error');
                status.className = 'error';
            }
            btn.textContent = 'Save Location';
            btn.disabled = pendingLat === null;
        })
        .catch(err => {
            status.textContent = 'Error: ' + err.message;
            status.className = 'error';
            btn.textContent = 'Save Location';
            btn.disabled = false;
        });
    }
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA8zSes6UGbYKIHNzCp3tny5RgccFruILI&callback=initDriverProfileMap" async defer></script>

</body>
</html>
