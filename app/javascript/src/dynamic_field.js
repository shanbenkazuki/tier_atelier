let categoryCounter = 5;
let rankCounter = 5;
const maxFields = 10;

function addField(event, counter, max, idPrefix, alertMaxMessage) {
    if (counter < max) {
        counter++;
        const newTextField = `
            <input class="form-control mt-2" type="text" name="tier[tier_${idPrefix}_attributes][${counter}][name]" id="tier_tier_${idPrefix}_attributes_${counter}_name">
            <input value="${counter}" autocomplete="off" type="hidden" name="tier[tier_${idPrefix}_attributes][${counter}][order]" id="tier_tier_${idPrefix}_attributes_${counter}_order">`;
        event.target.insertAdjacentHTML('beforebegin', newTextField);
    } else {
        alert(alertMaxMessage);
    }
    return counter;
}

function removeField(counter, min, idPrefix, alertMessage) {
    if (counter > min) {
        const elementToRemove = document.getElementById(`tier_${idPrefix}_${counter}`);
        if (elementToRemove) {
            elementToRemove.parentNode.removeChild(elementToRemove);
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
            categoryCounter = addField(event, categoryCounter, maxFields, 'categories', '最大カテゴリ数に達しました');
            break;
        case 'remove-category':
            categoryCounter = removeField(categoryCounter, 5, 'categories', 'これ以上フィールドを削除できません');
            break;
        case 'add-rank':
            rankCounter = addField(event, rankCounter, maxFields, 'ranks', '最大ランク数に達しました');
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