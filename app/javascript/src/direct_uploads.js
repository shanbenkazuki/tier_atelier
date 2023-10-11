function handleDirectUploadInitialize(event) {
  const { target, detail } = event;
  const { id, file } = detail;
  target.insertAdjacentHTML("beforebegin", `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename">${file.name}</span>
    </div>
  `);
}

function handleDirectUploadStart(event) {
  const { id } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.remove("direct-upload--pending");
}

function handleDirectUploadProgress(event) {
  const { id, progress } = event.detail;
  const progressElement = document.getElementById(`direct-upload-progress-${id}`);
  progressElement.style.width = `${progress}%`;
}

function handleDirectUploadError(event) {
  event.preventDefault();
  const { id, error } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.add("direct-upload--error");
  element.setAttribute("title", error);
}

function handleDirectUploadEnd(event) {
  const { id } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.add("direct-upload--complete");
}

// turbo:load イベントのハンドラ
function setupDirectUploadListeners() {
  // 既存のイベントリスナーを削除
  document.removeEventListener("direct-upload:initialize", handleDirectUploadInitialize);
  document.removeEventListener("direct-upload:start", handleDirectUploadStart);
  document.removeEventListener("direct-upload:progress", handleDirectUploadProgress);
  document.removeEventListener("direct-upload:error", handleDirectUploadError);
  document.removeEventListener("direct-upload:end", handleDirectUploadEnd);

  // イベントリスナーを再度追加
  document.addEventListener("direct-upload:initialize", handleDirectUploadInitialize);
  document.addEventListener("direct-upload:start", handleDirectUploadStart);
  document.addEventListener("direct-upload:progress", handleDirectUploadProgress);
  document.addEventListener("direct-upload:error", handleDirectUploadError);
  document.addEventListener("direct-upload:end", handleDirectUploadEnd);
}

// turbo:load イベントにリスナーを追加
document.addEventListener('turbo:load', setupDirectUploadListeners);
