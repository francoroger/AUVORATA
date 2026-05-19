/* ================================================
   AUVORATA — interações
   ================================================ */

(() => {
    'use strict';

    // ============================================
    // Ano no rodapé
    // ============================================
    const yearEl = document.getElementById('year');
    if (yearEl) yearEl.textContent = new Date().getFullYear();

    // ============================================
    // Header — adiciona blur ao scrollar
    // ============================================
    const header = document.getElementById('header');
    if (header) {
        const onScroll = () => {
            if (window.scrollY > 60) {
                header.classList.add('is-scrolled');
            } else {
                header.classList.remove('is-scrolled');
            }
        };
        window.addEventListener('scroll', onScroll, { passive: true });
        onScroll();
    }

    // ============================================
    // Reveal ao scroll
    // ============================================
    const revealEls = document.querySelectorAll('.reveal');

    if ('IntersectionObserver' in window) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry, i) => {
                if (entry.isIntersecting) {
                    // Pequeno escalonamento se houver vários no mesmo lote
                    const delay = i * 0.06;
                    entry.target.style.transitionDelay = `${delay}s`;
                    entry.target.classList.add('is-visible');
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.12,
            rootMargin: '0px 0px -60px 0px'
        });

        revealEls.forEach(el => observer.observe(el));
    } else {
        revealEls.forEach(el => el.classList.add('is-visible'));
    }

    // ============================================
    // Smooth scroll para âncoras
    // ============================================
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', (e) => {
            const targetId = anchor.getAttribute('href');
            if (targetId.length > 1) {
                const target = document.querySelector(targetId);
                if (target) {
                    e.preventDefault();
                    const headerOffset = 80;
                    const elementPosition = target.getBoundingClientRect().top + window.scrollY;
                    const offsetPosition = elementPosition - headerOffset;
                    window.scrollTo({ top: offsetPosition, behavior: 'smooth' });
                }
            }
        });
    });

})();
