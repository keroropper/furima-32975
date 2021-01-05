const pay = () => {
  Payjp.setPublicKey(process.env.PAYJP_PUBLIC_KEY);
  const form = document.getElementById("charge-form")     //
  form.addEventListener("submit", (e) => {               // イベント発火条件
    e.preventDefault();     //自動送信をキャンセルする役割   //

    const formResult = document.getElementById("charge-form"); //フォームのid取得
    const formData = new FormData(formResult);                //上記の情報を、FormDataオブジェクトとして生成 

    const card = {
      number: formData.get("order_info[number]"),         //
      exp_month: formData.get("order_info[month]"),      //
      exp_year: `20${formData.get("order_info[year]")}`,       // カードに関する情報を取得
      cvc: formData.get("order_info[cvc]"),            //
    };

    Payjp.createToken(card, (status, response) => {
      if (status == 200) {
        
        const token = response.id;    //response.id == トークン
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value=${token} name="token" type="hidden">`;
        
        
        renderDom.insertAdjacentHTML('beforeend', tokenObj); //charge-form要素内の最後に追加
      }

      document.getElementById("card-number").removeAttribute("name");      //
      document.getElementById("card-exp-month").removeAttribute("name");  // カード情報を削除
      document.getElementById("card-exp-year").removeAttribute("name");  //
      document.getElementById("card-cvc").removeAttribute("name");      //

      document.getElementById("charge-form").submit();             //送信する          
    });
  });
};

window.addEventListener("load", pay);