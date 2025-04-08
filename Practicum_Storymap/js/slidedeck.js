/*Only show rectangle if image is taller than text*/ 
window.addEventListener('load', () => {
  const layout = document.querySelector('.slide.layout1, .slide.layout3');
  const image = layout.querySelector('img');
  const text = layout.querySelector('.text');
  const rectangle = layout.querySelector('.rectangle');

  if (image.offsetHeight > text.offsetHeight) {
    rectangle.style.display = 'block';
  }
});