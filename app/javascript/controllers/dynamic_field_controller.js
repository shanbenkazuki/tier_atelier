import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["addField", "removeField"];

  initialize() {
    this.counter = 5;
    this.maxFields = 10;

    this.rankPlaceholders = [ "E", "F", "G", "H", "I"];
    this.categoryPlaceholders = [ "Balance", "Speeder", "Defender", "Supporter", "Attacker"];
  }

  addField(event) {
    event.preventDefault();
    if (this.counter >= this.maxFields) {
      alert('これ以上フィールドを追加できません');
      return;
    }
    
    const type = event.currentTarget.dataset.fieldType;

    const nameField = this.createInput(type, 'text', 'name', this.counter + 1);
    const orderField = this.createInput(type, 'hidden', 'order', this.counter + 1, this.counter + 1);

    this.insertInputsBeforeContainer(nameField, orderField);

    this.counter++;
  }
  
  removeField(event) {
    event.preventDefault();
    if (this.counter <= 5) {
      alert('これ以上フィールドを削除できません');
      return;
    }

    const type = event.currentTarget.dataset.fieldType;
    this.removeLastInputPair(type);
  }

  createInput(type, inputType, attrType, counter, value = "") {
    const input = document.createElement('input');
    input.classList.add('form-control', 'mt-2');
    input.type = inputType;
    input.name = `tier[tier_${type}_attributes][${counter}][${attrType}]`;
    input.id = `tier_tier_${type}_attributes_${counter}_${attrType}`;

    if (inputType === 'text') {
      if (type === 'ranks') {
        input.placeholder = this.rankPlaceholders[counter - 6] || "";
      } else if (type === 'categories') {
          input.placeholder = this.categoryPlaceholders[counter - 6] || "";
      }
    }

    if (value) input.value = value;

    return input;
  }

  insertInputsBeforeContainer(nameField, orderField) {
    const container = this.addFieldTarget.parentNode;
    container.parentNode.insertBefore(nameField, container);
    container.parentNode.insertBefore(orderField, container);
  }

  removeLastInputPair(type) {
    const lastTextField = document.querySelector(`input[id^='tier_tier_${type}_attributes_${this.counter}_name']`);
    const lastOrderField = document.querySelector(`input[id^='tier_tier_${type}_attributes_${this.counter}_order']`);

    if (lastTextField && lastOrderField) {
      lastTextField.remove();
      lastOrderField.remove();
      this.counter--;
    }
  }
}
