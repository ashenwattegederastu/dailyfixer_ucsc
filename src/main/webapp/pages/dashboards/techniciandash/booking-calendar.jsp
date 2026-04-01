<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>My Bookings - Technician Dashboard</title>
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=Lora:wght@400;500;600;700&family=IBM+Plex+Mono:wght@400;500;600&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/framework.css">
            <style>
                /* ── View Toggle ───────────────────────────────── */
                .page-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    flex-wrap: wrap;
                    gap: 1rem;
                    margin-bottom: 1.5rem;
                }

                .page-header h1 {
                    font-size: 2rem;
                    font-weight: 700;
                    color: var(--foreground);
                    margin: 0;
                }

                .view-toggle {
                    display: flex;
                    background: var(--muted);
                    border-radius: var(--radius-md);
                    overflow: hidden;
                    border: 1px solid var(--border);
                }

                .view-toggle button {
                    padding: 0.6rem 1.25rem;
                    border: none;
                    background: transparent;
                    color: var(--muted-foreground);
                    font-weight: 600;
                    font-size: 0.875rem;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    font-family: var(--font-sans);
                }

                .view-toggle button.active {
                    background: var(--primary);
                    color: var(--primary-foreground);
                }

                .view-toggle button:not(.active):hover {
                    background: var(--accent);
                    color: var(--accent-foreground);
                }

                /* ── Alert banners ─────────────────────────────── */
                .alert-banner {
                    padding: 1rem;
                    border-radius: var(--radius-md);
                    margin-bottom: 1rem;
                    font-weight: 500;
                }

                .alert-banner.success {
                    background: oklch(0.6290 0.1902 156.4499);
                    color: white;
                }

                .alert-banner.warning {
                    background: oklch(0.7336 0.1758 50.5517);
                    color: white;
                }

                /* ── Empty state ───────────────────────────────── */
                .empty-state-card {
                    text-align: center;
                    padding: 3rem;
                    background: var(--card);
                    border-radius: var(--radius);
                    border: 1px solid var(--border);
                }

                .empty-state-card p {
                    font-size: 1.125rem;
                    color: var(--muted-foreground);
                }

                /* ── Booking Cards (list view) ─────────────────── */
                .booking-list {
                    display: grid;
                    gap: 1.5rem;
                }

                .booking-card {
                    background: var(--card);
                    border-radius: var(--radius);
                    padding: 1.5rem;
                    box-shadow: var(--shadow-sm);
                    border: 1px solid var(--border);
                    transition: box-shadow 0.2s ease, transform 0.2s ease;
                }

                .booking-card:hover {
                    box-shadow: var(--shadow-md);
                    transform: translateY(-2px);
                }

                .booking-card-header {
                    display: grid;
                    grid-template-columns: 1fr auto;
                    gap: 1rem;
                    margin-bottom: 1rem;
                }

                .booking-card-header h3 {
                    font-size: 1.25rem;
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                }

                .booking-card-header p {
                    color: var(--muted-foreground);
                    margin-bottom: 0.25rem;
                }

                .status-badge {
                    display: inline-block;
                    padding: 0.25rem 0.75rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.8rem;
                    font-weight: 600;
                    white-space: nowrap;
                    height: fit-content;
                }

                .status-badge.accepted {
                    background: oklch(0.6290 0.1902 156.4499);
                    color: white;
                }

                .status-badge.awaiting {
                    background: var(--primary);
                    color: var(--primary-foreground);
                }

                .info-block {
                    background: var(--muted);
                    padding: 1rem;
                    border-radius: var(--radius-md);
                    margin-bottom: 1rem;
                }

                .info-block .label {
                    font-weight: 600;
                    margin-bottom: 0.5rem;
                }

                .info-block p {
                    color: var(--muted-foreground);
                }

                .booking-actions {
                    display: flex;
                    gap: 1rem;
                    flex-wrap: wrap;
                }

                .booking-actions a,
                .booking-actions button {
                    flex: 1;
                    min-width: 150px;
                    text-align: center;
                    padding: 0.75rem;
                    border: none;
                    border-radius: var(--radius-md);
                    font-weight: 600;
                    font-size: 0.9rem;
                    cursor: pointer;
                    text-decoration: none;
                    font-family: var(--font-sans);
                    transition: all 0.2s ease;
                }

                .btn-chat {
                    background: var(--primary);
                    color: var(--primary-foreground);
                }

                .btn-complete {
                    background: oklch(0.6290 0.1902 156.4499);
                    color: white;
                }

                .btn-cancel-booking {
                    background: var(--destructive);
                    color: var(--destructive-foreground);
                }

                .booking-actions a:hover,
                .booking-actions button:hover {
                    opacity: 0.9;
                    transform: translateY(-1px);
                }

                /* ── Calendar View ─────────────────────────────── */
                .calendar-controls {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 1rem;
                    flex-wrap: wrap;
                    gap: 0.75rem;
                }

                .calendar-nav {
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                }

                .calendar-nav button {
                    background: var(--secondary);
                    color: var(--secondary-foreground);
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    padding: 0.5rem 0.9rem;
                    font-size: 1rem;
                    cursor: pointer;
                    font-weight: 600;
                    transition: all 0.2s ease;
                    font-family: var(--font-sans);
                }

                .calendar-nav button:hover {
                    background: var(--accent);
                    color: var(--accent-foreground);
                }

                .calendar-month-label {
                    font-size: 1.25rem;
                    font-weight: 700;
                    color: var(--foreground);
                    min-width: 200px;
                    text-align: center;
                }

                .btn-today {
                    background: var(--primary);
                    color: var(--primary-foreground);
                    border: none;
                    border-radius: var(--radius-md);
                    padding: 0.5rem 1rem;
                    font-weight: 600;
                    font-size: 0.875rem;
                    cursor: pointer;
                    transition: all 0.2s ease;
                    font-family: var(--font-sans);
                }

                .btn-today:hover {
                    opacity: 0.9;
                }

                .calendar-grid {
                    display: grid;
                    grid-template-columns: repeat(7, 1fr);
                    background: var(--border);
                    border: 1px solid var(--border);
                    border-radius: var(--radius);
                    overflow: hidden;
                    gap: 1px;
                }

                .cal-day-header {
                    background: var(--muted);
                    padding: 0.6rem 0.5rem;
                    text-align: center;
                    font-weight: 600;
                    font-size: 0.8rem;
                    color: var(--muted-foreground);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                }

                .cal-day {
                    background: var(--card);
                    min-height: 110px;
                    padding: 0.5rem;
                    display: flex;
                    flex-direction: column;
                    transition: background-color 0.2s ease;
                }

                .cal-day:hover {
                    background: var(--accent);
                }

                .cal-day.other-month {
                    opacity: 0.35;
                }

                .cal-day.today {
                    background: oklch(0.6290 0.1902 156.4499 / 0.08);
                    box-shadow: inset 0 0 0 2px oklch(0.6290 0.1902 156.4499 / 0.3);
                }

                .cal-day-number {
                    font-weight: 700;
                    font-size: 0.85rem;
                    color: var(--muted-foreground);
                    margin-bottom: 0.35rem;
                }

                .cal-day.today .cal-day-number {
                    color: oklch(0.6290 0.1902 156.4499);
                }

                .cal-booking-pill {
                    display: block;
                    padding: 0.2rem 0.4rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.7rem;
                    font-weight: 600;
                    margin-bottom: 0.2rem;
                    cursor: pointer;
                    white-space: nowrap;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    transition: opacity 0.15s ease;
                }

                .cal-booking-pill:hover {
                    opacity: 0.85;
                }

                .cal-booking-pill.accepted {
                    background: oklch(0.6290 0.1902 156.4499);
                    color: white;
                }

                .cal-booking-pill.awaiting {
                    background: var(--primary);
                    color: var(--primary-foreground);
                }

                /* ── Modals ────────────────────────────────────── */
                .modal-overlay {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.55);
                    z-index: 2000;
                    align-items: center;
                    justify-content: center;
                    backdrop-filter: blur(2px);
                }

                .modal-content {
                    background: var(--card);
                    padding: 2rem;
                    border-radius: var(--radius);
                    max-width: 560px;
                    width: 90%;
                    box-shadow: var(--shadow-xl);
                    border: 1px solid var(--border);
                    max-height: 90vh;
                    overflow-y: auto;
                    animation: modalSlideIn 0.2s ease;
                }

                @keyframes modalSlideIn {
                    from {
                        transform: translateY(16px);
                        opacity: 0;
                    }

                    to {
                        transform: translateY(0);
                        opacity: 1;
                    }
                }

                .modal-content h3 {
                    font-size: 1.35rem;
                    font-weight: 700;
                    margin-bottom: 1rem;
                    color: var(--foreground);
                }

                /* ── Responsive ────────────────────────────────── */
                @media (max-width: 768px) {
                    .cal-day {
                        min-height: 70px;
                        padding: 0.3rem;
                    }

                    .cal-booking-pill {
                        font-size: 0.6rem;
                    }

                    .cal-day-number {
                        font-size: 0.75rem;
                    }

                    .calendar-month-label {
                        font-size: 1rem;
                        min-width: auto;
                    }
                }

                /* ── Recurring Contract Group (list view) ─────── */
                .recurring-contract-card {
                    border-left: 4px solid var(--primary);
                }

                .recurring-badge {
                    display: inline-block;
                    padding: 0.18rem 0.55rem;
                    border-radius: var(--radius-sm);
                    font-size: 0.72rem;
                    font-weight: 700;
                    background: var(--primary);
                    color: var(--primary-foreground);
                    margin-left: 0.4rem;
                    vertical-align: middle;
                }

                .months-toggle-btn {
                    background: none;
                    border: none;
                    color: var(--primary);
                    font-weight: 600;
                    font-size: 0.875rem;
                    cursor: pointer;
                    padding: 0;
                    text-decoration: underline;
                    font-family: var(--font-sans);
                    margin-top: 0.5rem;
                    display: inline-block;
                }

                .months-list {
                    display: none;
                    margin-top: 0.75rem;
                    border: 1px solid var(--border);
                    border-radius: var(--radius-md);
                    overflow: hidden;
                }

                .months-list table {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 0.875rem;
                }

                .months-list th {
                    background: var(--muted);
                    padding: 0.5rem 0.75rem;
                    text-align: left;
                    font-weight: 600;
                    color: var(--muted-foreground);
                    font-size: 0.8rem;
                }

                .months-list td {
                    padding: 0.5rem 0.75rem;
                    border-top: 1px solid var(--border);
                    color: var(--foreground);
                }

                .months-list tr:hover td {
                    background: var(--accent);
                }
            </style>
        </head>

        <body>
            <jsp:include page="sidebar.jsp" />

            <div class="dashboard-container">
                <!-- Page header with toggle -->
                <div class="page-header">
                    <h1>My Bookings</h1>
                    <div class="view-toggle">
                        <button id="btnListView" class="active" onclick="switchView('list')">📋 List View</button>
                        <button id="btnCalendarView" onclick="switchView('calendar')">📅 Calendar View</button>
                    </div>
                </div>

                <!-- Alert banners -->
                <c:if test="${param.completed}">
                    <div class="alert-banner success">Booking marked as completed!</div>
                </c:if>
                <c:if test="${param.cancelled}">
                    <div class="alert-banner warning">Booking cancelled successfully.</div>
                </c:if>

                <!-- Empty state -->
                <c:if test="${empty bookings}">
                    <div class="empty-state-card">
                        <p>No active bookings found.</p>
                    </div>
                </c:if>

                <!-- ════════════ LIST VIEW ════════════ -->
                <div id="list-view">
                    <div class="booking-list" id="listViewContainer"></div>
                </div>

                <!-- ════════════ CALENDAR VIEW ════════════ -->
                <div id="calendar-view" style="display: none;">
                    <div class="calendar-controls">
                        <div class="calendar-nav">
                            <button onclick="changeMonth(-1)">&#9664;</button>
                            <span id="calMonthLabel" class="calendar-month-label"></span>
                            <button onclick="changeMonth(1)">&#9654;</button>
                        </div>
                        <button class="btn-today" onclick="goToToday()">Today</button>
                    </div>
                    <div id="calendarGrid" class="calendar-grid"></div>
                </div>
            </div>

            <!-- ════════════ CANCEL MODAL ════════════ -->
            <div id="cancelModal" class="modal-overlay">
                <div class="modal-content">
                    <h3>Cancel Booking</h3>
                    <form id="cancelForm" method="post" action="${pageContext.request.contextPath}/bookings/cancel">
                        <input type="hidden" name="bookingId" id="cancelBookingId">
                        <div style="margin-bottom: 1rem;">
                            <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Reason for
                                Cancellation *</label>
                            <textarea name="cancellationReason" required rows="4"
                                placeholder="Please provide a reason..."
                                style="width: 100%; padding: 0.75rem; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--input); color: var(--foreground); resize: vertical; font-family: var(--font-sans);"></textarea>
                        </div>
                        <div style="display: flex; gap: 1rem;">
                            <button type="submit" class="btn-cancel-booking"
                                style="flex: 1; border-radius: var(--radius-md);">Cancel Booking</button>
                            <button type="button" onclick="closeCancelModal()"
                                style="flex: 1; background: var(--secondary); color: var(--secondary-foreground); padding: 0.75rem; border: 1px solid var(--border); border-radius: var(--radius-md); font-weight: 600; cursor: pointer; font-family: var(--font-sans);">Close</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ════════════ BOOKING DETAIL MODAL (calendar click) ════════════ -->
            <div id="detailModal" class="modal-overlay">
                <div class="modal-content">
                    <h3 id="detailServiceName"></h3>
                    <div class="info-block" style="margin-bottom: 0.75rem;">
                        <p><strong>Customer:</strong> <span id="detailCustomer"></span></p>
                        <p><strong>Phone:</strong> <span id="detailPhone"></span></p>
                        <p><strong>Date:</strong> <span id="detailDate"></span></p>
                        <p><strong>Status:</strong> <span id="detailStatusBadge"></span></p>
                    </div>
                    <div class="info-block" style="margin-bottom: 0.75rem;">
                        <p class="label">Problem Description:</p>
                        <p id="detailProblem"></p>
                    </div>
                    <div class="info-block" style="margin-bottom: 1rem;">
                        <p class="label">Location:</p>
                        <p id="detailAddress"></p>
                        <a id="detailMapLink" href="#" target="_blank"
                            style="color: var(--primary); text-decoration: underline; display: none; margin-top: 0.25rem;">View
                            on Google Maps</a>
                    </div>
                    <div id="detailActions" class="booking-actions"></div>
                    <div style="margin-top: 1rem; text-align: right;">
                        <button onclick="closeDetailModal()"
                            style="background: var(--secondary); color: var(--secondary-foreground); padding: 0.6rem 1.2rem; border: 1px solid var(--border); border-radius: var(--radius-md); font-weight: 600; cursor: pointer; font-family: var(--font-sans);">Close</button>
                    </div>
                </div>
            </div>

            <script>
                /* ── Serialize bookings from JSTL to JS ────────── */
                var bookings = [
                    <c:forEach var="booking" items="${bookings}" varStatus="loop">
                        {
                            id: ${booking.bookingId},
                        service: "${booking.serviceName}",
                        customer: "${booking.userName}",
                        date: "${booking.bookingDate}",
                        time: "${booking.bookingTime}",
                        status: "${booking.status}",
                        phone: "${booking.phoneNumber}",
                        problem: "${booking.problemDescription}",
                        address: "${booking.locationAddress}",
                        lat: "${booking.locationLatitude}",
                        lng: "${booking.locationLongitude}",
                        recurring: ${not empty booking.recurringContractId ? 'true' : 'false'},
                        recurringSeq: ${not empty booking.recurringSequence ? booking.recurringSequence : 0},
                        contractId: ${not empty booking.recurringContractId ? booking.recurringContractId : 0}
            }<c:if test="${!loop.last}">,</c:if>
                    </c:forEach>
                ];

                var contextPath = "${pageContext.request.contextPath}";

                /* ── View Toggle ───────────────────────────────── */
                function switchView(view) {
                    var listView = document.getElementById('list-view');
                    var calView = document.getElementById('calendar-view');
                    var btnList = document.getElementById('btnListView');
                    var btnCal = document.getElementById('btnCalendarView');

                    if (view === 'list') {
                        listView.style.display = 'block';
                        calView.style.display = 'none';
                        btnList.classList.add('active');
                        btnCal.classList.remove('active');
                    } else {
                        listView.style.display = 'none';
                        calView.style.display = 'block';
                        btnList.classList.remove('active');
                        btnCal.classList.add('active');
                        renderCalendar();
                    }
                }

                /* ── Calendar Logic ────────────────────────────── */
                var calDate = new Date();
                var monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
                var dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

                function renderCalendar() {
                    var year = calDate.getFullYear();
                    var month = calDate.getMonth();

                    document.getElementById('calMonthLabel').textContent = monthNames[month] + ' ' + year;

                    var firstDay = new Date(year, month, 1).getDay();
                    var daysInMonth = new Date(year, month + 1, 0).getDate();
                    var prevMonthDays = new Date(year, month, 0).getDate();

                    var grid = document.getElementById('calendarGrid');
                    grid.innerHTML = '';

                    /* Day headers */
                    for (var d = 0; d < 7; d++) {
                        var hdr = document.createElement('div');
                        hdr.className = 'cal-day-header';
                        hdr.textContent = dayNames[d];
                        grid.appendChild(hdr);
                    }

                    var today = new Date();
                    var todayStr = formatDateStr(today.getFullYear(), today.getMonth(), today.getDate());

                    /* Previous month's trailing days */
                    for (var i = 0; i < firstDay; i++) {
                        var dayNum = prevMonthDays - firstDay + i + 1;
                        var cell = createDayCell(year, month - 1, dayNum, true);
                        grid.appendChild(cell);
                    }

                    /* Current month days */
                    for (var day = 1; day <= daysInMonth; day++) {
                        var dateStr = formatDateStr(year, month, day);
                        var isToday = (dateStr === todayStr);
                        var cell = createDayCell(year, month, day, false, isToday, dateStr);
                        grid.appendChild(cell);
                    }

                    /* Fill remaining cells to complete the last week */
                    var totalCells = firstDay + daysInMonth;
                    var remaining = (7 - (totalCells % 7)) % 7;
                    for (var j = 1; j <= remaining; j++) {
                        var cell = createDayCell(year, month + 1, j, true);
                        grid.appendChild(cell);
                    }
                }

                function createDayCell(year, month, day, isOtherMonth, isToday, dateStr) {
                    var cell = document.createElement('div');
                    cell.className = 'cal-day';
                    if (isOtherMonth) cell.classList.add('other-month');
                    if (isToday) cell.classList.add('today');

                    var num = document.createElement('span');
                    num.className = 'cal-day-number';
                    num.textContent = day;
                    cell.appendChild(num);

                    /* Place booking pills for this day */
                    if (dateStr) {
                        var dayBookings = bookings.filter(function (b) { return b.date === dateStr; });
                        dayBookings.forEach(function (b) {
                            var pill = document.createElement('div');
                            pill.className = 'cal-booking-pill ' + (b.status === 'ACCEPTED' ? 'accepted' : 'awaiting');
                            var pillLabel = formatTime(b.time) + ' ' + b.service;
                            if (b.recurring) pillLabel = '\u21BB ' + pillLabel + ' (' + b.recurringSeq + '/12)';
                            pill.textContent = pillLabel;
                            pill.title = b.service + ' — ' + b.customer;
                            pill.onclick = function () { showDetailModal(b); };
                            cell.appendChild(pill);
                        });
                    }

                    return cell;
                }

                function formatDateStr(y, m, d) {
                    var dt = new Date(y, m, d);
                    var yy = dt.getFullYear();
                    var mm = String(dt.getMonth() + 1).padStart(2, '0');
                    var dd = String(dt.getDate()).padStart(2, '0');
                    return yy + '-' + mm + '-' + dd;
                }

                function formatTime(t) {
                    if (!t) return '';
                    var parts = t.split(':');
                    var h = parseInt(parts[0], 10);
                    var m = parts[1];
                    var ampm = h >= 12 ? 'PM' : 'AM';
                    h = h % 12 || 12;
                    return h + ':' + m + ' ' + ampm;
                }

                function changeMonth(offset) {
                    calDate.setMonth(calDate.getMonth() + offset);
                    renderCalendar();
                }

                function goToToday() {
                    calDate = new Date();
                    renderCalendar();
                }

                /* ── Booking Detail Modal (calendar) ───────────── */
                function showDetailModal(b) {
                    document.getElementById('detailServiceName').textContent = b.service;
                    document.getElementById('detailCustomer').textContent = b.customer;
                    document.getElementById('detailPhone').textContent = b.phone;
                    var dateText = b.date + ' at ' + formatTime(b.time);
                    if (b.recurring) dateText += '  \u2014  \u21BB Recurring (Month ' + b.recurringSeq + ' of 12)';
                    document.getElementById('detailDate').textContent = dateText;
                    document.getElementById('detailProblem').textContent = b.problem;
                    document.getElementById('detailAddress').textContent = b.address;

                    /* Status badge */
                    var badgeEl = document.getElementById('detailStatusBadge');
                    if (b.status === 'ACCEPTED') {
                        badgeEl.innerHTML = '<span class="status-badge accepted">ACCEPTED</span>';
                    } else {
                        badgeEl.innerHTML = '<span class="status-badge awaiting">AWAITING USER CONFIRM</span>';
                    }

                    /* Map link */
                    var mapLink = document.getElementById('detailMapLink');
                    if (b.lat && b.lng && b.lat !== '' && b.lng !== '') {
                        mapLink.href = 'https://www.google.com/maps?q=' + b.lat + ',' + b.lng;
                        mapLink.style.display = 'inline-block';
                    } else {
                        mapLink.style.display = 'none';
                    }

                    /* Action buttons */
                    var actions = document.getElementById('detailActions');
                    actions.innerHTML = '';

                    var chatBtn = document.createElement('a');
                    chatBtn.href = contextPath + '/chats/view?chatId=' + b.id;
                    chatBtn.className = 'btn-chat';
                    chatBtn.textContent = 'Open Chat';
                    actions.appendChild(chatBtn);

                    if (b.status === 'ACCEPTED') {
                        var completeForm = document.createElement('form');
                        completeForm.method = 'post';
                        completeForm.action = contextPath + '/bookings/complete';
                        completeForm.style.flex = '1';
                        completeForm.style.minWidth = '150px';
                        completeForm.innerHTML =
                            '<input type="hidden" name="bookingId" value="' + b.id + '">' +
                            '<input type="hidden" name="completionType" value="technician">' +
                            '<button type="submit" class="btn-complete" style="width:100%">Mark as Complete</button>';
                        actions.appendChild(completeForm);
                    }

                    var cancelBtn = document.createElement('button');
                    cancelBtn.className = 'btn-cancel-booking';
                    cancelBtn.textContent = 'Cancel Booking';
                    cancelBtn.onclick = function () {
                        closeDetailModal();
                        showCancelModal(b.id);
                    };
                    actions.appendChild(cancelBtn);

                    document.getElementById('detailModal').style.display = 'flex';
                }

                function closeDetailModal() {
                    document.getElementById('detailModal').style.display = 'none';
                }

                /* ── Cancel Modal ──────────────────────────────── */
                function showCancelModal(bookingId) {
                    document.getElementById('cancelBookingId').value = bookingId;
                    document.getElementById('cancelModal').style.display = 'flex';
                }

                function closeCancelModal() {
                    document.getElementById('cancelModal').style.display = 'none';
                }

                /* Close modals on overlay click */
                document.getElementById('cancelModal').addEventListener('click', function (e) {
                    if (e.target === this) closeCancelModal();
                });
                document.getElementById('detailModal').addEventListener('click', function (e) {
                    if (e.target === this) closeDetailModal();
                });

                /* ── List view rendering with recurring grouping ── */
                function escHtml(str) {
                    if (!str) return '';
                    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
                }

                function toggleMonths(listId, toggleId, total) {
                    var list = document.getElementById(listId);
                    var btn = document.getElementById(toggleId);
                    if (list.style.display === 'block') {
                        list.style.display = 'none';
                        btn.textContent = 'Show all ' + total + ' months \u25BC';
                    } else {
                        list.style.display = 'block';
                        btn.textContent = 'Hide months \u25B2';
                    }
                }

                function renderListView() {
                    var container = document.getElementById('listViewContainer');
                    container.innerHTML = '';

                    var nonRecurring = [];
                    var recurringGroups = {};
                    var recurringOrder = [];

                    bookings.forEach(function (b) {
                        if (!b.recurring || !b.contractId) {
                            nonRecurring.push(b);
                        } else {
                            var key = b.contractId;
                            if (!recurringGroups[key]) {
                                recurringGroups[key] = { contractId: key, months: [] };
                                recurringOrder.push(key);
                            }
                            recurringGroups[key].months.push(b);
                        }
                    });

                    recurringOrder.forEach(function (key) {
                        recurringGroups[key].months.sort(function (a, b) { return a.recurringSeq - b.recurringSeq; });
                    });

                    function statusBadgeHtml(status) {
                        if (status === 'ACCEPTED') return '<span class="status-badge accepted">ACCEPTED</span>';
                        return '<span class="status-badge awaiting">AWAITING USER CONFIRM</span>';
                    }

                    /* Recurring contract group cards */
                    recurringOrder.forEach(function (key) {
                        var group = recurringGroups[key];
                        var rep = group.months[0];
                        var total = group.months.length;
                        var today = new Date().toISOString().split('T')[0];
                        var next = group.months.find(function (m) { return m.date >= today; }) || rep;

                        var groupId = 'months-' + key;
                        var toggleId = 'toggle-' + key;

                        var monthRows = group.months.map(function (m) {
                            return '<tr>' +
                                '<td>Month ' + m.recurringSeq + '</td>' +
                                '<td>' + m.date + ' at ' + formatTime(m.time) + '</td>' +
                                '<td>' + statusBadgeHtml(m.status) + '</td>' +
                                '<td><button onclick="showCancelModal(' + m.id + ')" class="btn-cancel-booking" style="padding:0.25rem 0.6rem;font-size:0.75rem;min-width:auto;flex:none;">Cancel</button></td>' +
                                '</tr>';
                        }).join('');

                        var mapHtml = (rep.lat && rep.lng && rep.lat !== '' && rep.lng !== '')
                            ? '<a href="https://www.google.com/maps?q=' + rep.lat + ',' + rep.lng + '" target="_blank" style="color:var(--primary);text-decoration:underline;margin-top:0.25rem;display:inline-block;">View on Google Maps</a>'
                            : '';

                        var completeHtml = next.status === 'ACCEPTED'
                            ? '<form method="post" action="' + contextPath + '/bookings/complete" style="flex:1;min-width:150px;">'
                              + '<input type="hidden" name="bookingId" value="' + next.id + '">'
                              + '<input type="hidden" name="completionType" value="technician">'
                              + '<button type="submit" class="btn-complete" style="width:100%;">Mark as Complete</button>'
                              + '</form>'
                            : '';

                        var card = document.createElement('div');
                        card.className = 'booking-card recurring-contract-card';
                        card.innerHTML =
                            '<div class="booking-card-header">'
                            + '<div>'
                            + '<h3>' + escHtml(rep.service) + ' <span class="recurring-badge">\u21BB Recurring (' + total + ' months)</span></h3>'
                            + '<p><strong>Customer:</strong> ' + escHtml(rep.customer) + '</p>'
                            + '<p><strong>Phone:</strong> ' + escHtml(rep.phone) + '</p>'
                            + '<p><strong>Next:</strong> Month ' + next.recurringSeq + ' \u2014 ' + next.date + ' at ' + formatTime(next.time) + '</p>'
                            + '</div>'
                            + '<div>' + statusBadgeHtml(next.status) + '</div>'
                            + '</div>'
                            + '<div class="info-block"><p class="label">Problem Description:</p><p>' + escHtml(rep.problem) + '</p></div>'
                            + '<div class="info-block"><p class="label">Location:</p><p>' + escHtml(rep.address) + '</p>' + mapHtml + '</div>'
                            + '<button class="months-toggle-btn" id="' + toggleId + '" onclick="toggleMonths(\'' + groupId + '\',\'' + toggleId + '\',' + total + ')">'
                            + 'Show all ' + total + ' months \u25BC</button>'
                            + '<div class="months-list" id="' + groupId + '">'
                            + '<table><thead><tr><th>Month</th><th>Date &amp; Time</th><th>Status</th><th>Action</th></tr></thead>'
                            + '<tbody>' + monthRows + '</tbody></table></div>'
                            + '<div class="booking-actions" style="margin-top:1rem;">'
                            + '<a href="' + contextPath + '/chats/view?chatId=' + next.id + '" class="btn-chat">Open Chat</a>'
                            + completeHtml
                            + '<button onclick="showCancelModal(' + next.id + ')" class="btn-cancel-booking">Cancel Next</button>'
                            + '</div>';
                        container.appendChild(card);
                    });

                    /* Individual non-recurring booking cards */
                    nonRecurring.forEach(function (b) {
                        var mapHtml = (b.lat && b.lng && b.lat !== '' && b.lng !== '')
                            ? '<a href="https://www.google.com/maps?q=' + b.lat + ',' + b.lng + '" target="_blank" style="color:var(--primary);text-decoration:underline;margin-top:0.25rem;display:inline-block;">View on Google Maps</a>'
                            : '';

                        var completeHtml = b.status === 'ACCEPTED'
                            ? '<form method="post" action="' + contextPath + '/bookings/complete" style="flex:1;min-width:150px;">'
                              + '<input type="hidden" name="bookingId" value="' + b.id + '">'
                              + '<input type="hidden" name="completionType" value="technician">'
                              + '<button type="submit" class="btn-complete" style="width:100%;">Mark as Complete</button>'
                              + '</form>'
                            : '';

                        var card = document.createElement('div');
                        card.className = 'booking-card';
                        card.innerHTML =
                            '<div class="booking-card-header">'
                            + '<div>'
                            + '<h3>' + escHtml(b.service) + '</h3>'
                            + '<p><strong>Customer:</strong> ' + escHtml(b.customer) + '</p>'
                            + '<p><strong>Phone:</strong> ' + escHtml(b.phone) + '</p>'
                            + '<p><strong>Date:</strong> ' + b.date + ' at ' + formatTime(b.time) + '</p>'
                            + '</div>'
                            + '<div>' + statusBadgeHtml(b.status) + '</div>'
                            + '</div>'
                            + '<div class="info-block"><p class="label">Problem Description:</p><p>' + escHtml(b.problem) + '</p></div>'
                            + '<div class="info-block"><p class="label">Location:</p><p>' + escHtml(b.address) + '</p>' + mapHtml + '</div>'
                            + '<div class="booking-actions">'
                            + '<a href="' + contextPath + '/chats/view?chatId=' + b.id + '" class="btn-chat">Open Chat</a>'
                            + completeHtml
                            + '<button onclick="showCancelModal(' + b.id + ')" class="btn-cancel-booking">Cancel Booking</button>'
                            + '</div>';
                        container.appendChild(card);
                    });
                }

                renderListView();
            </script>
        </body>

        </html>