/* =====================================================
   AUVORATA — script.js (v0.1.0)
   - Validacao do formulario de cadastro
   - Ano dinamico no rodape
   ===================================================== */

// Atualiza ano no copyright
document.addEventListener('DOMContentLoaded', function () {
  var yearEl = document.getElementById('year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // Formulario de cadastro de email
  var form = document.getElementById('signup');
  var msg = document.getElementById('signup-msg');

  if (form && msg) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var email = (form.email.value || '').trim();
      var ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

      msg.classList.remove('show', 'error');
      // forca reflow para reanimar
      void msg.offsetWidth;

      if (!ok) {
        msg.textContent = 'verifique seu e-mail';
        msg.classList.add('show', 'error');
        return;
      }

      // TODO: Integrar com servico real (Formspree, Mailchimp, etc.)
      // Por enquanto, apenas feedback visual.
      msg.textContent = 'obrigado. avisaremos quando chegar.';
      msg.classList.add('show');
      form.reset();
    });
  }
});
