document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("form[name='pointForm']");
    const canvas = document.getElementById("resultCanvas");
    const ctx = canvas.getContext("2d");
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    let radius = null;
    const scale = canvas.width / 7; // Начальное масштабирование для R=1

    // Получаем все кнопки радиуса и скрытые поля
    const radiusButtons = document.querySelectorAll(".radius-btn");
    const radiusInput = document.getElementById("radius");
    const ySelect = document.getElementById("y_select");
    const yHidden = document.getElementById("y_hidden");

    // Переданные из JSP сохраненные значения
    const savedX = parseFloat(window.savedX) || NaN;
    const savedY = parseFloat(window.savedY) || NaN;
    const savedR = parseFloat(window.savedR) || 1;

    // Обработчик выбора радиуса через кнопки
    radiusButtons.forEach(button => {
        button.addEventListener("click", () => {
            // Удаляем класс 'active' у всех кнопок и aria-pressed
            radiusButtons.forEach(btn => {
                btn.classList.remove("active");
                btn.setAttribute("aria-pressed", "false");
            });
            // Добавляем класс 'active' к выбранной кнопке и aria-pressed
            button.classList.add("active");
            button.setAttribute("aria-pressed", "true");
            // Устанавливаем значение в скрытое поле
            radiusInput.value = button.getAttribute("data-value");
            // Обновляем локальную переменную радиуса
            radius = parseFloat(radiusInput.value);
            // Перерисовываем канвас с новым радиусом
            drawCanvas();
            if (!isNaN(savedX) && !isNaN(savedY) && !isNaN(savedR)) {
                drawPoint(savedX, savedY); // Рисуем точку
            }
        });
    });

    // Инициализация формы и канваса с сохранёнными значениями
    if (!isNaN(savedR)) {
        radius = savedR;
        // Установка активной кнопки радиуса
        radiusButtons.forEach(btn => {
            if (parseFloat(btn.getAttribute("data-value")) === radius) {
                btn.classList.add("active");
                btn.setAttribute("aria-pressed", "true");
            } else {
                btn.classList.remove("active");
                btn.setAttribute("aria-pressed", "false");
            }
        });
        radiusInput.value = radius;
    }

    // Устанавливаем сохранённое значение Y
    if (!isNaN(savedY)) {
        ySelect.value = savedY;
        yHidden.value = savedY;
    }

    drawCanvas();
    // Отрисовка сохранённой точки, если координаты валидны
    if (!isNaN(savedX) && !isNaN(savedY) && !isNaN(savedR)) {
        drawPoint(savedX, savedY); // Рисуем точку
    }

    // Обработчик выбора значения Y через select
    ySelect.addEventListener("change", () => {
        const selectedY = ySelect.value;
        yHidden.value = selectedY;
    });

    // Обработчик клика по канвасу
    canvas.addEventListener("click", (event) => {
        radius = parseFloat(radiusInput.value);

        if (!radius || isNaN(radius)) {
            showToast("Установите радиус области перед выбором точки.", "warning");
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
        let x = form.elements["x"].value.trim();
        const y = yHidden.value.trim(); // Используем скрытое поле
        const r = form.elements["radius"].value.trim();

        // Проверка на пустые значения
        if (!isValidNumber(x) || !isValidNumber(y) || !isValidNumber(r)) {
            event.preventDefault();
            showToast("Пожалуйста, введите корректные числовые значения для X, Y и радиуса.", "error");
            return;
        }

        x = parseFloat(x);

        // Проверка диапазона X
        if (x < -5 || x > 3) {
            event.preventDefault();
            showToast("X должен быть в допустимом диапазоне [-5, 3].", "warning");
            return;
        }

        // Проверка количества знаков после запятой
        const xString = form.elements["x"].value.trim();
        if (!/^[-]?\d+(\.\d{1,2})?$/.test(xString)) {
            event.preventDefault();
            showToast("Допустимо максимум две цифры после запятой: например, 1.01.", "warning");
            return;
        }


        // Если все проверки пройдены, отправляем форму
        console.log(x, y, r);
    });

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
        ctx.arc(centerX + x * scale, centerY - y * scale, 4, 0, Math.PI * 2); // Увеличен радиус точки для видимости
        ctx.fill();
        ctx.closePath();
    }

    function submitPoint(x, y) {
        form.elements["x"].value = x;
        yHidden.value = y; // Устанавливаем значение в скрытое поле
        form.submit();
    }

    function isValidNumber(value) {
        return !isNaN(value) && value !== "";
    }

    // Функция отображения сообщений
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
