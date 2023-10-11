let categoryCounter = 5;
let rankCounter = 5;
const maxFields = 10; // 例として、最大10個のフィールドを設定

function addField(event, counter, max, idPrefix, alertMaxMessage) {
    if (counter < max) {
        counter++;
        const newTextField = `<input class='form-control mt-2' type='text' name='tier[${idPrefix}_${counter}]' id='tier_${idPrefix}_${counter}'>`;
        event.target.insertAdjacentHTML('beforebegin', newTextField);
        document.getElementById(`tier_${idPrefix}_column_num`).value = counter;
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
        document.getElementById(`tier_${idPrefix}_column_num`).value = counter;
    } else {
        alert(alertMessage);
    }
    return counter;
}

function handleBodyClick(event) {
    switch (event.target.id) {
        case 'add-category':
            categoryCounter = addField(event, categoryCounter, maxFields, 'category', '最大カテゴリ数に達しました');
            break;
        case 'remove-category':
            categoryCounter = removeField(categoryCounter, 5, 'category', 'これ以上フィールドを削除できません');
            break;
        case 'add-rank':
            rankCounter = addField(event, rankCounter, maxFields, 'rank', '最大ランク数に達しました');
            break;
        case 'remove-rank':
            rankCounter = removeField(rankCounter, 5, 'rank', 'これ以上フィールドを削除できません');
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