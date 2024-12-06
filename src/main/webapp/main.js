document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form[name='pointForm']");
    const canvas = document.getElementById("resultCanvas");
    const ctx = canvas.getContext("2d");
    let radius = null;

    // Validate form inputs
    form.addEventListener("submit", (event) => {
        const x = form.elements["x"].value.trim();
        const y = form.elements["y"].value.trim();
        radius = form.elements["radius"].value.trim();

        if (!isValidNumber(x) || !isValidNumber(y) || !isValidNumber(radius)) {
            event.preventDefault();
            showToast("Пожалуйста, введите корректные числовые значения для X, Y и радиуса.", "error");
        }
    });

    // Handle canvas click
    canvas.addEventListener("click", (event) => {
        if (!radius || isNaN(radius)) {
            showToast("Установите радиус области перед выбором точки.", "warning");
            return;
        }

        const rect = canvas.getBoundingClientRect();
        const mouseX = event.clientX - rect.left;
        const mouseY = event.clientY - rect.top;

        const canvasCenterX = canvas.width / 2;
        const canvasCenterY = canvas.height / 2;
        const scaleFactor = canvas.width / 2 / radius; // Scale based on radius

        const pointX = ((mouseX - canvasCenterX) / scaleFactor).toFixed(2);
        const pointY = ((canvasCenterY - mouseY) / scaleFactor).toFixed(2);

        submitPoint(pointX, pointY);
    });

    // Draw initial canvas
    drawCanvas();

    function drawCanvas() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // Draw axes
        ctx.strokeStyle = "#A6E22E";
        ctx.lineWidth = 2;

        ctx.beginPath();
        ctx.moveTo(canvas.width / 2, 0);
        ctx.lineTo(canvas.width / 2, canvas.height);
        ctx.moveTo(0, canvas.height / 2);
        ctx.lineTo(canvas.width, canvas.height / 2);
        ctx.stroke();

        // Draw area (example: quarter-circle in top-right quadrant)
        if (radius && !isNaN(radius)) {
            ctx.fillStyle = "rgba(102, 217, 239, 0.5)";
            ctx.beginPath();
            ctx.arc(canvas.width / 2, canvas.height / 2, radius * (canvas.width / 2 / radius), 0, Math.PI / 2);
            ctx.lineTo(canvas.width / 2, canvas.height / 2);
            ctx.closePath();
            ctx.fill();
        }
    }

    function submitPoint(x, y) {
        // Fill form and submit programmatically
        form.elements["x"].value = x;
        form.elements["y"].value = y;
        form.submit();
    }

    function isValidNumber(value) {
        return !isNaN(value) && value !== "";
    }

    // Toast functionality
    function showToast(message, type) {
        const toast = document.createElement("div");
        toast.className = `toast toast-${type}`;
        toast.textContent = message;

        document.body.appendChild(toast);

        setTimeout(() => {
            toast.classList.add("show");
        }, 100);

        setTimeout(() => {
            toast.classList.remove("show");
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
});