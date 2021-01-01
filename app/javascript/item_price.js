

window.addEventListener('load', () => {
  const priceInput = document.getElementById("item-price");
  priceInput.addEventListener('input', () => {
    const inputValue = priceInput.value;

    const addTaxDom = document.getElementById('add-tax-price');
      addTaxDom.innerHTML = (Math.floor(inputValue * 0.1)).toLocaleString();

    const Profit = document.getElementById('profit');
      const Tax = (Math.floor(inputValue * 0.1));
      Profit.innerHTML = (Math.floor(inputValue - Tax)).toLocaleString();
  });
});

