const BASE = 2000;
const PER_CHAR = 50;
const MIN = 3000;
const MAX = 12000;
const EXIT_TIME = 350;
const audio = new Audio("audio/notify.mp3");
audio.volume = 0.5;

const typeMessage = {
    success: "img/success.png",
    msg: "img/msg.png",
    answer: "img/msg.png",
    error: "img/failed.png"
}

window.addEventListener("message", function(event) {
    const TIME = Math.min(MAX, Math.max(MIN, BASE + event.data.message.length * PER_CHAR));
    const $msg = document.createElement("div");
    const $icon = document.createElement("div");
    const $image = document.createElement("img");
    const $content = document.createElement("div");
    const $bar = document.createElement("div");

    $msg.classList.add("notify");
    $msg.style.setProperty("--durata", TIME + "ms");
    $icon.classList.add("notify-icon");
    $image.src = typeMessage[event.data.type];
    $content.classList.add("notify-text");
    $content.textContent = event.data.message;
    
    switch (event.data.type) {
        case "success":
            $bar.classList.add("notify-bar-success");
            break;
        case "msg":
            $bar.classList.add("notify-bar-msg");
            break;
        case "answer":
            $bar.classList.add("notify-bar-answer");
            break;
        case "error":
            $bar.classList.add("notify-bar-error");
            break;
        default:
            $bar.classList.add("notify-bar-undefined");
            break;
    }

    $icon.appendChild($image);
    $msg.appendChild($icon);
    $msg.appendChild($content);
    $msg.appendChild($bar);
    document.getElementById("notify-container").appendChild($msg);
    
    if(event.data.type === "msg") {
        audio.play();
    }

    setTimeout(function () {
        $msg.classList.add("uscita");
        setTimeout(function () {
            $msg.remove();
        }, EXIT_TIME);
    }, TIME);
});