
document.addEventListener("DOMContentLoaded", function() {
    let currentQuestion = 0;
    let score = 0;
    let answered = false;
    let timer;
    let timeLeft;
    let startTime;

    const questions = [
        {
            question: "Which HTML tag is used to create a hyperlink?",
            options: ["<link>", "<a>", "<href>", "<url>"],
            correct: 1
        },
        {
            question: "What does HTML stand for?",
            options: [
                "Hyper Text Markup Language",
                "High Tech Modern Language",
                "Hyper Transfer Markup Language",
                "Home Tool Markup Language"
            ],
            correct: 0
        },
        {
            question: "Which tag is used to create an unordered list in HTML?",
            options: ["<ol>", "<li>", "<ul>", "<list>"],
            correct: 2
        },
        {
            question: "What is the correct HTML element for inserting a line break?",
            options: ["<break>", "<lb>", "<br>", "<newline>"],
            correct: 2
        },
        {
            question: "Which HTML attribute specifies an alternate text for an image?",
            options: ["title", "alt", "description", "caption"],
            correct: 1
        },
        {
            question: "What is the correct HTML for creating a checkbox?",
            options: [
                "<input type=\"check\">",
                "<checkbox>",
                "<input type=\"checkbox\">",
                "<check>"
            ],
            correct: 2
        },
        {
            question: "Which HTML element defines the title of a document?",
            options: ["<meta>", "<head>", "<header>", "<title>"],
            correct: 3
        },
        {
            question: "What is the correct HTML element for the largest heading?",
            options: ["<heading>", "<h6>", "<head>", "<h1>"],
            correct: 3
        },
        {
            question: "Which HTML attribute is used to define inline styles?",
            options: ["class", "style", "css", "format"],
            correct: 1
        },
        {
            question: "What is the correct HTML for creating a table?",
            options: ["<table>", "<tab>", "<tb>", "<grid>"],
            correct: 0
        }
    ];

    const startButton = document.getElementById("startButton");
    const retakeButton = document.getElementById("retakeButton");
    const backToStartButton = document.getElementById("backToStartButton");

    startButton.addEventListener("click", startQuiz);
    retakeButton.addEventListener("click", resetQuiz);
    backToStartButton.addEventListener("click", showStartScreen);

    function startTimer() {
        timeLeft = 30;
        updateTimerDisplay();
        timer = setInterval(() => {
            timeLeft--;
            updateTimerDisplay();
            if (timeLeft <= 0) {
                clearInterval(timer);
                checkAnswer(-1); // Force timeout
            }
        }, 1000);
    }

    function updateTimerDisplay() {
        document.getElementById("timer").textContent = `Time: ${timeLeft}s`;
    }

    function startQuiz() {
        document.getElementById("start-screen").style.display = "none";
        document.getElementById("quiz-content").style.display = "block";
        currentQuestion = 0;
        score = 0;
        startTime = Date.now();
        loadQuestion();
    }

    function showStartScreen() {
        document.getElementById("start-screen").style.display = "block";
        document.getElementById("quiz-content").style.display = "none";
        document.getElementById("results").style.display = "none";
    }

    function loadQuestion() {
        clearInterval(timer);
        startTimer();
        
        const question = questions[currentQuestion];
        document.getElementById("question").textContent = question.question;
        
        const optionsContainer = document.getElementById("options");
        optionsContainer.innerHTML = "";
        
        question.options.forEach((option, index) => {
            const button = document.createElement("button");
            button.className = "option w-100 text-start";
            button.textContent = option;
            button.onclick = () => checkAnswer(index);
            optionsContainer.appendChild(button);
        });

        const progress = ((currentQuestion) / questions.length) * 100;
        document.querySelector(".progress-bar").style.width = `${progress}%`;
        
        document.getElementById("feedback").style.display = "none";
        answered = false;
    }

    function checkAnswer(selectedOption) {
        if (answered) return;
        answered = true;
        clearInterval(timer);

        const correct = questions[currentQuestion].correct;
        const feedback = document.getElementById("feedback");
        const options = document.querySelectorAll(".option");

        if (selectedOption === -1) {
            feedback.className = "feedback alert alert-warning";
            feedback.textContent = "Time is up! The correct answer was: " + questions[currentQuestion].options[correct];
        } else {
            options[correct].classList.add("correct");
            
            if (selectedOption === correct) {
                score++;
                feedback.className = "feedback alert alert-success";
                feedback.textContent = "Correct!";
            } else {
                options[selectedOption].classList.add("incorrect");
                feedback.className = "feedback alert alert-danger";
                feedback.textContent = "Incorrect. The correct answer is: " + questions[currentQuestion].options[correct];
            }
        }
        feedback.style.display = "block";

        setTimeout(() => {
            currentQuestion++;
            if (currentQuestion < questions.length) {
                loadQuestion();
            } else {
                showResults();
            }
        }, 1500);
    }

    function showResults() {
        const timeTaken = Math.round((Date.now() - startTime) / 1000);
        document.getElementById("question-container").style.display = "none";
        document.getElementById("results").style.display = "block";
        document.getElementById("score").textContent = Math.round((score / questions.length) * 100);
        document.getElementById("time-taken").textContent = timeTaken;
        document.getElementById("timer").style.display = "none";
    }

    function resetQuiz() {
        currentQuestion = 0;
        score = 0;
        startTime = Date.now();
        document.getElementById("question-container").style.display = "block";
        document.getElementById("results").style.display = "none";
        document.getElementById("timer").style.display = "block";
        loadQuestion();
    }
});
