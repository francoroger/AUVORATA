/* =====================================================
   AUVORATA — script.js (v0.5.0)
   - Ano dinamico no rodape
   - IntersectionObserver para revelar secoes ao rolar
   ===================================================== */

document.addEventListener('DOMContentLoaded', function () {

  // Ano dinamico
  var yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // Observer para revelar secoes ao entrar no viewport
  var sections = document.querySelectorAll('.section');
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('in-view');
        }
      });
    }, {
      threshold: 0.3,
      rootMargin: '0px'
    });
    sections.forEach(function (s) { io.observe(s); });
  } else {
    // Fallback: mostra tudo de uma vez
    sections.forEach(function (s) { s.classList.add('in-view'); });
  }

});
