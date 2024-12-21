document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form[name='pointForm']");
    const canvas = document.getElementById("resultCanvas");
    const ctx = canvas.getContext("2d");
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const scale = canvas.width / 7; // Начальное масштабирование для R=1

    // Получаем элементы формы
    const xSelect = document.getElementById("x_select");
    const yInput = document.getElementById("y_input");
    const rInput = document.getElementById("r_input");

    // Переданные из JSP сохраненные значения
    const savedX = parseFloat(window.savedX) || NaN;
    const savedY = parseFloat(window.savedY) || NaN;
    const savedR = parseFloat(window.savedR) || NaN;

    // Инициализация формы и канваса с сохранёнными значениями
    if (!isNaN(savedX)) {
        xSelect.value = savedX;
    }
    if (!isNaN(savedY)) {
        yInput.value = savedY;
    }
    if (!isNaN(savedR)) {
        rInput.value = savedR;
    }

    drawCanvas();
    if (!isNaN(savedX) && !isNaN(savedY) && !isNaN(savedR)) {
        drawPoint(savedX, savedY); // Рисуем точку
    }

    // Обработчик клика по канвасу
    canvas.addEventListener("click", (event) => {
        const r = parseFloat(rInput.value);

        if (!r || isNaN(r) || r < 1 || r > 4) {
            showToast("Установите корректное значение радиуса (1 ≤ R ≤ 4) перед выбором точки.", "warning");
            return;
        }

        const rect = canvas.getBoundingClientRect();
        const mouseX = event.clientX - rect.left;
        const mouseY = event.clientY - rect.top;

        const pointX = ((mouseX - centerX) / scale).toFixed(2);
        const pointY = ((centerY - mouseY) / scale).toFixed(2);

        // Устанавливаем значения в форму и отправляем
        submitPoint(pointX, pointY);
    });

    // Обработчик отправки формы для валидации
    form.addEventListener("submit", (event) => {
        const x = xSelect.value.trim();
        const y = yInput.value.trim();
        const r = rInput.value.trim();

        // Проверка на пустые значения
        if (!isValidNumber(x) || !isValidNumber(y) || !isValidNumber(r)) {
            event.preventDefault();
            showToast("Пожалуйста, введите корректные числовые значения для X, Y и радиуса.", "error");
            return;
        }

        const yValue = parseFloat(y);
        const rValue = parseFloat(r);

        // Проверка диапазонов
        if (yValue < -3 || yValue > 5) {
            event.preventDefault();
            showToast("Y должен быть в допустимом диапазоне [-3, 5].", "warning");
            return;
        }
        if (rValue < 1 || rValue > 4) {
            event.preventDefault();
            showToast("R должен быть в допустимом диапазоне [1, 4].", "warning");
            return;
        }

        // Проверка количества знаков после запятой
        if (!isValidPrecision(y) || !isValidPrecision(r)) {
            event.preventDefault();
            showToast("Допустимо максимум две цифры после запятой для Y и R.", "warning");
            return;
        }

        // Если все проверки пройдены, отправляем форму
        console.log(x, y, r);
    });

    function drawCanvas() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        drawAxes();

        const r = parseFloat(rInput.value);
        if (!isNaN(r) && r > 0) {
            drawCircle(r);
            drawTriangle(r);
            drawSquare(r);
        }
    }

    function drawAxes() {
        ctx.beginPath();
        ctx.moveTo(0, centerY);
        ctx.lineTo(canvas.width, centerY);
        ctx.strokeStyle = "#50E3C2";
        ctx.lineWidth = 2;
        ctx.stroke();

        // Стрелка по оси X
        ctx.moveTo(canvas.width - 10, centerY - 5);
        ctx.lineTo(canvas.width, centerY);
        ctx.lineTo(canvas.width - 10, centerY + 5);
        ctx.fillStyle = "#50E3C2";
        ctx.fill();
        ctx.closePath();

        // Ось Y
        ctx.beginPath();
        ctx.moveTo(centerX, 0);
        ctx.lineTo(centerX, canvas.height);
        ctx.strokeStyle = "#50E3C2";
        ctx.lineWidth = 2;
        ctx.stroke();

        // Стрелка по оси Y
        ctx.moveTo(centerX - 5, 10);
        ctx.lineTo(centerX, 0);
        ctx.lineTo(centerX + 5, 10);
        ctx.fillStyle = "#50E3C2";
        ctx.fill();
        ctx.closePath();

        // Подписи осей
        ctx.font = "12px Arial";
        ctx.fillStyle = "#50E3C2";
        ctx.fillText("X", canvas.width - 14, centerY + 19);
        ctx.fillText("Y", centerX + 10, 14);
    }

    function drawCircle(R) {
        ctx.fillStyle = "rgba(134,58,51,0.34)";
        ctx.beginPath();
        ctx.arc(centerX, centerY, (R / 2) * scale, -Math.PI, -Math.PI / 2);
        ctx.lineTo(centerX, centerY);
        ctx.fill();
        ctx.closePath();
    }

    function drawTriangle(R) {
        ctx.fillStyle = "rgba(134,58,51,0.34)";
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.lineTo(centerX, centerY - (R / 2) * scale);
        ctx.lineTo(centerX + (R / 2) * scale, centerY);
        ctx.lineTo(centerX, centerY);
        ctx.fill();
        ctx.closePath();
    }

    function drawSquare(R) {
        ctx.fillStyle = "rgba(134,58,51,0.34)";
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
        ctx.fillStyle = "#50E3C2";
        ctx.beginPath();
        ctx.arc(centerX + x * scale, centerY - y * scale, 4, 0, Math.PI * 2);
        ctx.fill();
        ctx.closePath();
    }

    function submitPoint(x, y) {
        form.elements["x_select"].value = x;
        form.elements["y_input"].value = y;
        form.submit();
    }

    function isValidNumber(value) {
        return !isNaN(value) && value !== "";
    }

    function isValidPrecision(value) {
        return /^-?\d+(\.\d{1,2})?$/.test(value); // Допустимо максимум две цифры после запятой
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
