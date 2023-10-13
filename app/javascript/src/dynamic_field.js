const defaultFieldsNum = 5
let categoryCounter = defaultFieldsNum;
let rankCounter = defaultFieldsNum;
const maxFields = 10;
const rankPlaceholders = [ "E", "F", "G", "H", "I"];
const categoryPlaceholders = [ "Balance", "Speeder", "Defender", "Supporter", "Attacker"];

function addField(event, counter, max, idPrefix, alertMaxMessage, placeholders) {
    if (counter < max) {
        const placeholder = placeholders[counter - defaultFieldsNum] || "";
        counter++;
        const newTextField = `
            <input class="form-control mt-2" type="text" name="tier[tier_${idPrefix}_attributes][${counter}][name]" id="tier_tier_${idPrefix}_attributes_${counter}_name" placeholder="${placeholder}">
            <input value="${counter}" autocomplete="off" type="hidden" name="tier[tier_${idPrefix}_attributes][${counter}][order]" id="tier_tier_${idPrefix}_attributes_${counter}_order">`;
        event.target.insertAdjacentHTML('beforebegin', newTextField);
    } else {
        alert(alertMaxMessage);
    }
    return counter;
}


function removeField(counter, min, idPrefix, alertMessage) {
    if (counter > min) {
        const inputNameToRemove = document.getElementById(`tier_tier_${idPrefix}_attributes_${counter}_name`);
        const inputOrderToRemove = document.getElementById(`tier_tier_${idPrefix}_attributes_${counter}_order`);

        if (inputNameToRemove) {
            inputNameToRemove.parentNode.removeChild(inputNameToRemove);
        }
        if (inputOrderToRemove) {
            inputOrderToRemove.parentNode.removeChild(inputOrderToRemove);
        }
        counter--;
    } else {
        alert(alertMessage);
    }
    return counter;
}

function handleBodyClick(event) {
    switch (event.target.id) {
        case 'add-category':
            categoryCounter = addField(event, categoryCounter, maxFields, 'categories', '最大カテゴリ数に達しました', categoryPlaceholders);
            break;
        case 'remove-category':
            categoryCounter = removeField(categoryCounter, 5, 'categories', 'これ以上フィールドを削除できません');
            break;
        case 'add-rank':
            rankCounter = addField(event, rankCounter, maxFields, 'ranks', '最大ランク数に達しました', rankPlaceholders);
            break;
        case 'remove-rank':
            rankCounter = removeField(rankCounter, 5, 'ranks', 'これ以上フィールドを削除できません');
            break;
    }
}

function setupListeners() {
    // 既存のイベントリスナーを削除
    document.body.removeEventListener('click', handleBodyClick);
    // イベントリスナーを再度追加
    document.body.addEventListener('click', handleBodyClick);
}

document.addEventListener('turbo:load', setupListeners);