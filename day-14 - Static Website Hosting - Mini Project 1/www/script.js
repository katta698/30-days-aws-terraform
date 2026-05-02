let count = 0;

function incrementCounter() {
  count++;
  document.getElementById("counter").innerText = `Clicks: ${count}`;
}

function toggleTheme() {
  document.body.classList.toggle("dark");

  const selectedTheme = document.body.classList.contains("dark") ? "dark" : "light";
  localStorage.setItem("theme", selectedTheme);
}

window.onload = function () {
  const savedTheme = localStorage.getItem("theme");

  if (savedTheme === "dark") {
    document.body.classList.add("dark");
  }
};