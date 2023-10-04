import React, {useState} from 'react';
import {DndContext} from '@dnd-kit/core';

import {Droppable} from './Droppable';
import {Draggable} from './Draggable';

function App() {
  // コンテナのIDリストを定義
  const containers = ['A', 'B', 'C'];

  // ドラッグアイテムの親（どのコンテナに所属しているか）を管理するためのステート
  const [parent, setParent] = useState(null);

  // ドラッグ可能なマークアップを定義
  const draggableMarkup = (
    <Draggable id="draggable">Drag me</Draggable>
  );

  // UIのレンダリングを返す
  return (
    // DndContextで全体をラップして、ドラッグ＆ドロップの機能を提供
    <DndContext onDragEnd={handleDragEnd}>
      {/* parentがnullの場合、ドラッグアイテムを表示 */}
      {parent === null ? draggableMarkup : null}

      {/* すべてのコンテナをマップして表示 */}
      {containers.map((id) => (
        // Droppableコンポーネントを使用して各コンテナをレンダリング
        <Droppable key={id} id={id}>
          {/* ドラッグアイテムの現在の親がこのコンテナのIDと一致する場合、ドラッグアイテムを表示 */}
          {parent === id ? draggableMarkup : 'Drop here'}
        </Droppable>
      ))}
    </DndContext>
  );

  // ドラッグが終了したときのイベントハンドラ
  function handleDragEnd(event) {
    const {over} = event;

    // アイテムがコンテナの上にドロップされた場合、そのコンテナを親として設定
    // それ以外の場合、親をnullにリセット
    setParent(over ? over.id : null);
  }
}

// Appコンポーネントをエクスポートする
export default App;
