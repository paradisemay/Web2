document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form[name='pointForm']");
    const canvas = document.getElementById("resultCanvas");
    const ctx = canvas.getContext("2d");
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    let radius = null;
    const scale = canvas.width / 4; // Масштаб для рисования

    // Получаем все кнопки радиуса и скрытое поле
    const radiusButtons = document.querySelectorAll(".radius-btn");
    const radiusInput = document.getElementById("radius");

    // Обработчик выбора радиуса через кнопки
    radiusButtons.forEach(button => {
        button.addEventListener("click", () => {
            // Удаляем класс 'active' у всех кнопок
            radiusButtons.forEach(btn => btn.classList.remove("active"));
            // Добавляем класс 'active' к выбранной кнопке
            button.classList.add("active");
            // Устанавливаем значение в скрытое поле
            radiusInput.value = button.getAttribute("data-value");
            // Обновляем локальную переменную радиуса
            radius = parseFloat(radiusInput.value);
            // Перерисовываем канвас с новым радиусом
            drawCanvas();
        });
    });

    // Обработчик отправки формы для валидации
    form.addEventListener("submit", (event) => {
        const x = form.elements["x"].value.trim();
        const y = form.elements["y"].value.trim();
        const r = form.elements["radius"].value.trim();
        console.log(x, y, r);

        if (!isValidNumber(x) || !isValidNumber(y) || !isValidNumber(r)) {
            event.preventDefault();
            showToast("Пожалуйста, введите корректные числовые значения для X, Y и радиуса.", "error");
        }
    });

    // Обработчик клика по канвасу
    canvas.addEventListener("click", (event) => {
        radius = document.getElementById("radius").value.trim();


        if (!radius || isNaN(radius)) {
            showToast("Установите радиус области перед выбором точки.", "warning");
            return;
        }

        const rect = canvas.getBoundingClientRect();
        const mouseX = event.clientX - rect.left;
        const mouseY = event.clientY - rect.top;

        const pointX = ((mouseX - centerX) / scale).toFixed(2);
        const pointY = ((centerY - mouseY) / scale).toFixed(2);

        submitPoint(pointX, pointY);
    });

    // Update canvas when radius changes
    document.getElementById("radius").addEventListener("input", () => {
        radius = parseFloat(document.getElementById("radius").value.trim());
        drawCanvas();
    });

    // Отрисовка канваса при загрузке страницы
    drawCanvas();

    function drawCanvas() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        drawAxes();

        if (!isNaN(radius) && radius > 0) {
            drawCircle(radius);
            drawTriangle(radius);
            drawSquare(radius);
        }
    }

    function drawAxes() {
        ctx.beginPath();
        ctx.moveTo(0, centerY);
        ctx.lineTo(canvas.width, centerY);
        ctx.strokeStyle = "black";
        ctx.lineWidth = 2;
        ctx.stroke();

        ctx.moveTo(canvas.width - 10, centerY - 5);
        ctx.lineTo(canvas.width, centerY);
        ctx.lineTo(canvas.width - 10, centerY + 5);
        ctx.fillStyle = "black";
        ctx.fill();
        ctx.closePath();

        // Ось Y
        ctx.beginPath();
        ctx.moveTo(centerX, 0);
        ctx.lineTo(centerX, canvas.height);
        ctx.strokeStyle = "black";
        ctx.lineWidth = 2;
        ctx.stroke();

        ctx.moveTo(centerX - 5, 10);
        ctx.lineTo(centerX, 0);
        ctx.lineTo(centerX + 5, 10);
        ctx.fillStyle = "black";
        ctx.fill();
        ctx.closePath();

        // Подписи осей
        ctx.font = "12px Arial";
        ctx.fillStyle = "black";
        ctx.fillText("X", canvas.width - 14, centerY + 19);
        ctx.fillText("Y", centerX + 10, 14);
    }

    function drawCircle(R) {
        ctx.fillStyle = "rgba(66,170,255,0.34)";
        ctx.beginPath();
        ctx.arc(centerX, centerY, (R / 2) * scale, -Math.PI, -Math.PI / 2);
        ctx.lineTo(centerX, centerY);
        ctx.fill();
        ctx.closePath();
    }

    function drawTriangle(R) {
        ctx.fillStyle = "rgba(66,170,255,0.34)";
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.lineTo(centerX, centerY - (R / 2) * scale);
        ctx.lineTo(centerX + (R / 2) * scale, centerY);
        ctx.lineTo(centerX, centerY);
        ctx.fill();
        ctx.closePath();
    }

    function drawSquare(R) {
        ctx.fillStyle = "rgba(66,170,255,0.34)";
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.lineTo(centerX, centerY + R * scale);
        ctx.lineTo(centerX - R * scale, centerY + R * scale);
        ctx.lineTo(centerX - R * scale, centerY);
        ctx.lineTo(centerX, centerY);
        ctx.fill();
        ctx.closePath();
    }

    function drawPoint(x, y) {
        ctx.fillStyle = "#000dff";
        ctx.beginPath();
        ctx.arc(centerX + x * scale, centerY - y * scale, 2, 0, Math.PI * 2);
        ctx.fill();
        ctx.closePath();
    }

    function submitPoint(x, y) {
        form.elements["x"].value = x;
        form.elements["y"].value = y;
        form.submit();
    }

    function isValidNumber(value) {
        return !isNaN(value) && value !== "";
    }

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
