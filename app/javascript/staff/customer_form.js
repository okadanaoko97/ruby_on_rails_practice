function toggle_home_address_fields() {
  const checked = $("input#form_inputs_home_address").prop("checked");
  $("fieldset#home-address-fields input").prop("disabled", !checked);
  $("fieldset#home-address-fields select").prop("disabled", !checked);
  $("fieldset#home-address-fields").toggle(checked);
}

function toggle_work_address_fields() {
  const checked = $("input#form_inputs_work_address").prop("checked");
  $("fieldset#work-address-fields input").prop("disabled", !checked);
  $("fieldset#work-address-fields select").prop("disabled", !checked);
  $("fieldset#work-address-fields").toggle(checked);
}

$(document).on("ready turbolinks:load", () => {
  toggle_home_address_fields();
  toggle_work_address_fields();
  $("input#form_inputs_home_address").on("click", () => {
    toggle_home_address_fields();
  });
  $("input#form_inputs_work_address").on("click", () => {
    toggle_work_address_fields();
  });
});




// toggle()メソッドは指定された条件がtrueの場合に要素を表示し、falseの場合には要素を非表示にします。
// 関数呼び出しは、ページロード時にそれぞれの住所入力フィールド（自宅と職場）の表示状態を適切に設定し,チェックボックスの状態（に基づいてフィールドを表示または非表示にする。
// それぞれのチェックボックスがクリックされた時に、対応する住所フィールドの表示状態を切り替えるための関数を呼び出しクリックするたびに、関連するフィールドセットの表示または非表示と有効または無効を切り替えることができます。