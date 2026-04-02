(function () {
    // ── helpers ──────────────────────────────────────────────────────────────

    function setupCanvas(canvas) {
        if (!canvas) {
            return null;
        }

        var rect = canvas.getBoundingClientRect();
        var dpr = window.devicePixelRatio || 1;
        var width = Math.max(1, Math.floor(rect.width * dpr));
        var height = Math.max(1, Math.floor(rect.height * dpr));

        if (canvas.width !== width || canvas.height !== height) {
            canvas.width = width;
            canvas.height = height;
        }

        var ctx = canvas.getContext("2d");
        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

        return {
            ctx: ctx,
            width: rect.width,
            height: rect.height
        };
    }

    // ── chart 1: Order Status – vertical bars, one per status ───────────────

    function drawOrderStatusBars(canvas, labels, values, colors, textColor, gridColor) {
        var c = setupCanvas(canvas);
        if (!c) {
            return;
        }
        var ctx = c.ctx, W = c.width, H = c.height;
        ctx.clearRect(0, 0, W, H);

        var pad = { t: 30, b: 52, l: 28, r: 12 };
        var pw = W - pad.l - pad.r;
        var ph = H - pad.t - pad.b;
        if (pw <= 0 || ph <= 0) {
            return;
        }

        var n = labels.length;
        var maxV = Math.max(1, Math.max.apply(null, values));
        var step = pw / n;
        var barW = Math.max(4, step * 0.55);
        var shortLabels = ["Pending", "Processing", "Out Delivery", "Delivered"];

        // Horizontal grid lines (3 lines: at 0%, 50%, 100%)
        ctx.strokeStyle = gridColor;
        ctx.lineWidth = 1;
        ctx.font = "11px Inter, sans-serif";
        ctx.fillStyle = textColor;
        ctx.textAlign = "right";
        for (var g = 0; g <= 2; g++) {
            var gy = pad.t + ph * g / 2;
            ctx.beginPath();
            ctx.moveTo(pad.l, gy);
            ctx.lineTo(pad.l + pw, gy);
            ctx.stroke();
            ctx.fillText(String(Math.round(maxV * (1 - g / 2))), pad.l - 4, gy + 4);
        }

        // Bars + labels
        for (var i = 0; i < n; i++) {
            var x = pad.l + i * step + (step - barW) / 2;
            var barH = values[i] > 0 ? Math.max(2, (values[i] / maxV) * ph) : 0;
            var y = pad.t + ph - barH;

            ctx.fillStyle = colors[i];
            ctx.fillRect(x, y, barW, barH);

            // Count above bar
            ctx.fillStyle = textColor;
            ctx.textAlign = "center";
            ctx.font = "bold 12px Inter, sans-serif";
            ctx.fillText(String(values[i]), x + barW / 2, Math.max(pad.t - 4, y - 6));

            // Label below x-axis
            ctx.font = "11px Inter, sans-serif";
            var lbl = shortLabels[i] || labels[i];
            ctx.fillText(lbl, x + barW / 2, H - pad.b + 16);

            // Colour dot next to label
            ctx.fillStyle = colors[i];
            ctx.beginPath();
            ctx.arc(x + barW / 2 - ctx.measureText(lbl).width / 2 - 7, H - pad.b + 12, 4, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    // ── chart 2: Orders & Revenue – bars for orders, dotted line for revenue ─

    function drawOrdersRevenue(canvas, labels, orders, revenue, textColor, gridColor) {
        var c = setupCanvas(canvas);
        if (!c) {
            return;
        }
        var ctx = c.ctx, W = c.width, H = c.height;
        ctx.clearRect(0, 0, W, H);

        // Legend row at top
        var legendH = 20;
        var pad = { t: legendH + 14, b: 30, l: 32, r: 20 };
        var pw = W - pad.l - pad.r;
        var ph = H - pad.t - pad.b;
        if (pw <= 0 || ph <= 0) {
            return;
        }

        var n = labels.length;
        var maxOrders = Math.max(1, Math.max.apply(null, orders));
        var maxRevenue = Math.max(1, Math.max.apply(null, revenue));
        var step = pw / Math.max(1, n);
        var barW = Math.max(4, step * 0.5);

        function yOrd(v) { return pad.t + ph - (v / maxOrders) * ph; }
        function yRev(v) { return pad.t + ph - (v / maxRevenue) * ph; }

        // Grid lines (3)
        ctx.strokeStyle = gridColor;
        ctx.lineWidth = 1;
        ctx.font = "11px Inter, sans-serif";
        ctx.fillStyle = textColor;
        ctx.textAlign = "right";
        for (var g = 0; g <= 2; g++) {
            var gy = pad.t + ph * g / 2;
            ctx.beginPath();
            ctx.moveTo(pad.l, gy);
            ctx.lineTo(pad.l + pw, gy);
            ctx.stroke();
            ctx.fillText(String(Math.round(maxOrders * (1 - g / 2))), pad.l - 4, gy + 4);
        }

        // Bars (orders)
        for (var i = 0; i < n; i++) {
            var x = pad.l + i * step + (step - barW) / 2;
            var barTop = yOrd(orders[i]);
            var barH = pad.t + ph - barTop;

            ctx.fillStyle = "rgba(59,130,246,0.75)";
            if (barH > 0) {
                ctx.fillRect(x, barTop, barW, barH);
            }

            // Count on top of bar (only if non-zero)
            if (orders[i] > 0) {
                ctx.fillStyle = textColor;
                ctx.textAlign = "center";
                ctx.font = "bold 11px Inter, sans-serif";
                ctx.fillText(String(orders[i]), x + barW / 2, Math.max(pad.t - 2, barTop - 4));
            }

            // X-axis date labels
            ctx.fillStyle = textColor;
            ctx.textAlign = "center";
            ctx.font = "11px Inter, sans-serif";
            ctx.fillText(labels[i], pad.l + i * step + step / 2, H - 6);
        }

        // Revenue line
        ctx.beginPath();
        for (var j = 0; j < n; j++) {
            var px = pad.l + j * step + step / 2;
            var py = yRev(revenue[j]);
            if (j === 0) {
                ctx.moveTo(px, py);
            } else {
                ctx.lineTo(px, py);
            }
        }
        ctx.strokeStyle = "#8b5cf6";
        ctx.lineWidth = 2;
        ctx.stroke();

        // Dots on revenue line
        for (var k = 0; k < n; k++) {
            if (revenue[k] > 0) {
                ctx.beginPath();
                ctx.arc(pad.l + k * step + step / 2, yRev(revenue[k]), 3, 0, Math.PI * 2);
                ctx.fillStyle = "#8b5cf6";
                ctx.fill();
            }
        }

        // Legend
        ctx.fillStyle = "rgba(59,130,246,0.75)";
        ctx.fillRect(pad.l, 6, 10, 10);
        ctx.fillStyle = textColor;
        ctx.textAlign = "left";
        ctx.font = "11px Inter, sans-serif";
        ctx.fillText("Orders", pad.l + 14, 15);

        ctx.fillStyle = "#8b5cf6";
        ctx.fillRect(pad.l + 72, 6, 10, 10);
        ctx.fillStyle = textColor;
        ctx.fillText("Revenue (LKR)", pad.l + 86, 15);
    }

    // ── chart 3: Most Selling Items – clean horizontal bars ──────────────────

    function drawHorizontalBars(canvas, labels, values, textColor, gridColor) {
        var c = setupCanvas(canvas);
        if (!c) {
            return;
        }
        var ctx = c.ctx, W = c.width, H = c.height;
        ctx.clearRect(0, 0, W, H);

        var labelMaxW = Math.min(140, W * 0.38);
        var pad = { t: 14, b: 14, l: labelMaxW + 12, r: 40 };
        var pw = W - pad.l - pad.r;
        var ph = H - pad.t - pad.b;
        if (pw <= 0 || ph <= 0) {
            return;
        }

        var n = labels.length;
        var rowH = ph / Math.max(1, n);
        var barH = Math.min(22, rowH * 0.55);
        var maxV = Math.max(1, Math.max.apply(null, values));

        ctx.font = "12px Inter, sans-serif";

        for (var i = 0; i < n; i++) {
            var y = pad.t + i * rowH + (rowH - barH) / 2;
            var fillW = (values[i] / maxV) * pw;

            // Track background
            ctx.fillStyle = gridColor;
            ctx.fillRect(pad.l, y, pw, barH);

            // Filled portion
            ctx.fillStyle = "rgba(59,130,246,0.70)";
            ctx.fillRect(pad.l, y, fillW, barH);

            // Label (right-aligned, clipped to labelMaxW)
            ctx.fillStyle = textColor;
            ctx.textAlign = "right";
            ctx.save();
            ctx.beginPath();
            ctx.rect(0, y, pad.l - 8, barH + 4);
            ctx.clip();
            ctx.fillText(labels[i], pad.l - 8, y + barH - 5);
            ctx.restore();

            // Value – inside bar if wide enough, otherwise after bar (but capped to canvas)
            ctx.fillStyle = textColor;
            ctx.textAlign = "left";
            ctx.font = "bold 12px Inter, sans-serif";
            var valStr = String(values[i]);
            var valX = pad.l + fillW + 6;
            // If value would overflow right edge, draw it inside the bar
            if (valX + ctx.measureText(valStr).width > W - 4) {
                ctx.fillStyle = "#fff";
                valX = pad.l + fillW - ctx.measureText(valStr).width - 6;
                if (valX < pad.l + 4) {
                    valX = pad.l + 4;
                }
            }
            ctx.fillText(valStr, valX, y + barH - 5);
            ctx.font = "12px Inter, sans-serif";
        }
    }

    // ── render ────────────────────────────────────────────────────────────────

    function renderStoreDashboardCharts() {
        var chartData = window.storeDashData;
        if (!chartData) {
            return;
        }

        var isDark = document.documentElement.classList.contains("dark");
        var textColor = isDark ? "rgba(255,255,255,0.9)" : "rgba(30,30,30,0.85)";
        var gridColor = isDark ? "rgba(255,255,255,0.10)" : "rgba(0,0,0,0.08)";

        var statusValues = chartData.statusValues || [0, 0, 0, 0];
        var statusLabels = chartData.statusLabels || ["Pending", "Processing", "Out for Delivery", "Delivered"];
        var statusColors = ["#f59e0b", "#ec4899", "#06b6d4", "#10b981"];

        var mostSelling = chartData.mostSelling || [];
        var sellLabels = mostSelling.map(function (item) {
            var name = item && item.name ? String(item.name) : "";
            return name.length > 22 ? name.substring(0, 21) + "\u2026" : name;
        });
        var sellValues = mostSelling.map(function (item) {
            return item && typeof item.qty === "number" ? item.qty : 0;
        });

        if (sellLabels.length === 0) {
            sellLabels = ["No sales yet"];
            sellValues = [0];
        }

        drawOrderStatusBars(
            document.getElementById("chartOrderStatus"),
            statusLabels,
            statusValues,
            statusColors,
            textColor,
            gridColor
        );

        drawOrdersRevenue(
            document.getElementById("chartOrdersOverTime"),
            chartData.dayLabels || [],
            chartData.orderCounts || [],
            chartData.revenueByDay || [],
            textColor,
            gridColor
        );

        drawHorizontalBars(
            document.getElementById("chartMostSelling"),
            sellLabels,
            sellValues,
            textColor,
            gridColor
        );
    }

    var resizeTimer;
    function renderWithDebounce() {
        window.clearTimeout(resizeTimer);
        resizeTimer = window.setTimeout(renderStoreDashboardCharts, 120);
    }

    var themeObserver = new MutationObserver(function () {
        renderStoreDashboardCharts();
    });

    themeObserver.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ["class"]
    });

    window.addEventListener("resize", renderWithDebounce);

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", renderStoreDashboardCharts);
    } else {
        renderStoreDashboardCharts();
    }
})();
