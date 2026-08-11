/* ============================================
   Helpers
============================================ */

const reduceMotion =
  window.matchMedia(
    "(prefers-reduced-motion: reduce)"
  ).matches;


/* ============================================
   Current year
============================================ */

const year =
  document.querySelector("#year");

if (year) {
  year.textContent =
    new Date().getFullYear();
}


/* ============================================
   Initial page transition
============================================ */

window.addEventListener(
  "DOMContentLoaded",
  () => {

    requestAnimationFrame(() => {

      requestAnimationFrame(() => {
        document.body.classList.add(
          "page-ready"
        );
      });

    });

  }
);


/* ============================================
   Navigation transitions
============================================ */

document
  .querySelectorAll("a[href]")
  .forEach((link) => {

    link.addEventListener(
      "click",
      (event) => {

        const href =
          link.getAttribute("href");


        if (!href) {
          return;
        }


        /*
         * Hash link:
         * smooth scroll inside this page.
         */

        if (href.startsWith("#")) {

          const target =
            document.querySelector(href);


          if (!target) {
            return;
          }


          event.preventDefault();


          target.scrollIntoView({
            behavior:
              reduceMotion
                ? "auto"
                : "smooth",

            block: "start"
          });


          return;
        }


        /*
         * Links opening another tab
         * don't need our transition.
         */

        if (
          link.target === "_blank"
        ) {
          return;
        }


        /*
         * Internal pages:
         * animate screen before navigation.
         */

        const url =
          new URL(
            link.href,
            window.location.href
          );


        if (
          url.origin !==
          window.location.origin
        ) {
          return;
        }


        if (reduceMotion) {
          return;
        }


        event.preventDefault();


        document.body.classList.remove(
          "page-ready"
        );

        document.body.classList.add(
          "page-leave"
        );


        setTimeout(
          () => {
            window.location.href =
              url.href;
          },
          650
        );

      }

    );

  });


/* ============================================
   Scroll reveal
============================================ */

const revealElements =
  document.querySelectorAll(
    ".reveal"
  );


if (reduceMotion) {

  revealElements.forEach(
    (element) => {
      element.classList.add(
        "visible"
      );
    }
  );

}
else {

  const observer =
    new IntersectionObserver(

      (entries) => {

        entries.forEach(
          (entry) => {

            if (
              entry.isIntersecting
            ) {

              entry.target
                .classList.add(
                  "visible"
                );

              observer.unobserve(
                entry.target
              );

            }

          }
        );

      },

      {
        threshold: 0.12
      }

    );


  revealElements.forEach(
    (element) => {
      observer.observe(
        element
      );
    }
  );

}


/* ============================================
   Mouse reactive gradient
============================================ */

let mouseX =
  window.innerWidth / 2;

let mouseY =
  window.innerHeight / 2;


let targetX =
  mouseX;

let targetY =
  mouseY;


window.addEventListener(
  "pointermove",
  (event) => {

    targetX =
      event.clientX;

    targetY =
      event.clientY;

  }
);


function updateMouseGlow() {

  mouseX +=
    (targetX - mouseX)
    * 0.12;

  mouseY +=
    (targetY - mouseY)
    * 0.12;


  document.documentElement
    .style.setProperty(
      "--mouse-x",
      `${mouseX}px`
    );


  document.documentElement
    .style.setProperty(
      "--mouse-y",
      `${mouseY}px`
    );


  requestAnimationFrame(
    updateMouseGlow
  );

}


if (!reduceMotion) {
  updateMouseGlow();
}


/* ============================================
   Particle system
============================================ */

const canvas =
  document.querySelector(
    "#particles"
  );


if (
  canvas &&
  !reduceMotion
) {

  const ctx =
    canvas.getContext("2d");


  let width;
  let height;
  let dpr;


  const pointer = {
    x:
      window.innerWidth / 2,

    y:
      window.innerHeight / 2,

    active:
      false
  };


  const particles = [];


  function resizeCanvas() {

    dpr =
      Math.min(
        window.devicePixelRatio || 1,
        2
      );


    width =
      window.innerWidth;

    height =
      window.innerHeight;


    canvas.width =
      width * dpr;

    canvas.height =
      height * dpr;


    canvas.style.width =
      `${width}px`;

    canvas.style.height =
      `${height}px`;


    ctx.setTransform(
      dpr,
      0,
      0,
      dpr,
      0,
      0
    );


    createParticles();

  }


  function particleCount() {

    const area =
      width * height;


    return Math.min(
      90,

      Math.max(
        35,
        Math.floor(
          area / 23000
        )
      )

    );

  }


  function createParticles() {

    particles.length = 0;


    const count =
      particleCount();


    for (
      let i = 0;
      i < count;
      i++
    ) {

      particles.push({

        x:
          Math.random()
          * width,

        y:
          Math.random()
          * height,

        vx:
          (
            Math.random()
            - 0.5
          ) * 0.25,

        vy:
          (
            Math.random()
            - 0.5
          ) * 0.25,

        radius:
          Math.random()
          * 1.3
          + 0.45,

        alpha:
          Math.random()
          * 0.5
          + 0.15

      });

    }

  }


  function updateParticles() {

    for (
      const particle
      of particles
    ) {

      particle.x +=
        particle.vx;

      particle.y +=
        particle.vy;


      /*
       * Wrap particles around screen.
       */

      if (
        particle.x < -10
      ) {

        particle.x =
          width + 10;

      }


      if (
        particle.x >
        width + 10
      ) {

        particle.x =
          -10;

      }


      if (
        particle.y < -10
      ) {

        particle.y =
          height + 10;

      }


      if (
        particle.y >
        height + 10
      ) {

        particle.y =
          -10;

      }


      /*
       * Very subtle pointer influence.
       */

      if (pointer.active) {

        const dx =
          pointer.x
          - particle.x;

        const dy =
          pointer.y
          - particle.y;


        const distanceSquared =
          dx * dx
          +
          dy * dy;


        const radius =
          180;


        if (
          distanceSquared <
          radius * radius
        ) {

          const distance =
            Math.sqrt(
              distanceSquared
            );


          if (
            distance > 0
          ) {

            const force =
              (
                1
                -
                distance
                / radius
              )
              * 0.006;


            particle.vx -=
              (
                dx
                / distance
              )
              * force;


            particle.vy -=
              (
                dy
                / distance
              )
              * force;

          }

        }

      }


      /*
       * Prevent endless acceleration.
       */

      particle.vx *=
        0.997;

      particle.vy *=
        0.997;

    }

  }


  function drawParticles() {

    ctx.clearRect(
      0,
      0,
      width,
      height
    );


    /*
     * Connections
     */

    const maxDistance =
      125;


    for (
      let i = 0;
      i < particles.length;
      i++
    ) {

      const a =
        particles[i];


      for (
        let j = i + 1;
        j < particles.length;
        j++
      ) {

        const b =
          particles[j];


        const dx =
          a.x - b.x;

        const dy =
          a.y - b.y;


        const distance =
          Math.sqrt(
            dx * dx
            +
            dy * dy
          );


        if (
          distance <
          maxDistance
        ) {

          const opacity =
            (
              1
              -
              distance
              /
              maxDistance
            )
            * 0.12;


          ctx.beginPath();

          ctx.moveTo(
            a.x,
            a.y
          );

          ctx.lineTo(
            b.x,
            b.y
          );


          ctx.strokeStyle =
            `rgba(
              80,
              245,
              225,
              ${opacity}
            )`;


          ctx.lineWidth =
            0.6;


          ctx.stroke();

        }

      }

    }


    /*
     * Particle dots
     */

    for (
      const particle
      of particles
    ) {

      ctx.beginPath();


      ctx.arc(
        particle.x,
        particle.y,
        particle.radius,
        0,
        Math.PI * 2
      );


      ctx.fillStyle =
        `rgba(
          110,
          240,
          230,
          ${particle.alpha}
        )`;


      ctx.fill();

    }

  }


  function animateParticles() {

    updateParticles();

    drawParticles();


    requestAnimationFrame(
      animateParticles
    );

  }


  window.addEventListener(
    "pointermove",
    (event) => {

      pointer.x =
        event.clientX;

      pointer.y =
        event.clientY;

      pointer.active =
        true;

    }
  );


  document.addEventListener(
    "mouseleave",
    () => {

      pointer.active =
        false;

    }
  );


  window.addEventListener(
    "resize",
    resizeCanvas
  );


  resizeCanvas();

  animateParticles();

}