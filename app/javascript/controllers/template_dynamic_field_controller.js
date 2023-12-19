import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="template-dynamic-field"
export default class extends Controller {
  static targets = ["addRankField", "removeRankField", "addCategoryField", "removeCategoryField"];

  initialize() {
    // rankfieldの6~10を非表示にする
    for (let i = 6; i <= 10; i++) {
      // もしtemplate_template_ranks_attributes_があれば非表示にする
      if (document.querySelector(`input[id^='template_template_ranks_attributes_${i}_name']` && `input[id^='template_template_ranks_attributes_${i}_order']`)) {
        document.querySelector(`input[id^='template_template_ranks_attributes_${i}_name']`).style.display = "none";
        document.querySelector(`input[id^='template_template_ranks_attributes_${i}_order']`).style.display = "none";
      }
    }
    // categoryfieldの1~10を非表示にする
    for (let i = 1; i <= 10; i++) {
      // もしtemplate_template_categories_attributes_があれば非表示にする
      if (document.querySelector(`input[id^='template_template_categories_attributes_${i}_name']` && `input[id^='template_template_categories_attributes_${i}_order']`)) {
        document.querySelector(`input[id^='template_template_categories_attributes_${i}_name']`).style.display = "none";
        document.querySelector(`input[id^='template_template_categories_attributes_${i}_order']`).style.display = "none";
      }
    }

    this.rankCounter = 6;
    this.categoryCounter = 1;
    this.maxFields = 11;
    this.minRankFields = 6;
    this.minCategoryFields = 1;
  }

  addRankField(event) {
    event.preventDefault();
    if (this.rankCounter >= this.maxFields) {
      alert('これ以上フィールドを追加できません');
      return;
    }

    // rankcoounterのtemplate_template_ranks_attributesを表示する
    document.querySelector(`input[id^='template_template_ranks_attributes_${this.rankCounter}_name']`).style.display = "block";
    document.querySelector(`input[id^='template_template_ranks_attributes_${this.rankCounter}_order']`).style.display = "block";

    this.rankCounter++;
  }

  removeRankField(event) {
    event.preventDefault();
    if (this.rankCounter <= this.minRankFields) {
      alert('これ以上フィールドを削除できません');
      return;
    }

    // rankcoounterのtemplate_template_ranks_attributesを非表示にする
    document.querySelector(`input[id^='template_template_ranks_attributes_${this.rankCounter - 1}_name']`).style.display = "none";
    document.querySelector(`input[id^='template_template_ranks_attributes_${this.rankCounter - 1}_order']`).style.display = "none";

    this.rankCounter--;
  }

  addCategoryField(event) {
    event.preventDefault();
    if (this.categoryCounter >= this.maxFields) {
      alert('これ以上フィールドを追加できません');
      return;
    }

    // categorycoounterのtemplate_template_categories_attributesを表示する
    document.querySelector(`input[id^='template_template_categories_attributes_${this.categoryCounter}_name']`).style.display = "block";
    document.querySelector(`input[id^='template_template_categories_attributes_${this.categoryCounter}_order']`).style.display = "block";

    this.categoryCounter++;
  }

  removeCategoryField(event) {
    event.preventDefault();
    if (this.categoryCounter <= this.minCategoryFields) {
      alert('これ以上フィールドを削除できません');
      return;
    }

    // categorycoounterのtemplate_template_categories_attributesを非表示にする
    document.querySelector(`input[id^='template_template_categories_attributes_${this.categoryCounter - 1}_name']`).style.display = "none";
    document.querySelector(`input[id^='template_template_categories_attributes_${this.categoryCounter - 1}_order']`).style.display = "none";

    this.categoryCounter--;
  }

  //style.display = "none"のinputを削除する
  removeHiddenInput() {
    const hiddenInputs = document.querySelectorAll("input[style='display: none;']");
    hiddenInputs.forEach((hiddenInput) => {
      hiddenInput.remove();
    });
  }
}
