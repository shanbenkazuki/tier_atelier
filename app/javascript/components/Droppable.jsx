// Reactライブラリをインポートする
import React from 'react';
// @dnd-kit/coreから、ドロップ可能な機能を提供するフックをインポートする
import {useDroppable} from '@dnd-kit/core';

// Droppableという関数コンポーネントを定義する
export function Droppable(props) {
  // useDroppableフックを使って、ドロップの状態や要素の参照を取得する
  const {isOver, setNodeRef} = useDroppable({
    id: props.id,
  });
  // ドロップエリアの上にドラッグアイテムがある場合、テキストの色を緑にするスタイルを定義する
  const style = {
    color: isOver ? 'green' : undefined,
  };
  
  // コンポーネントのUIを返す
  return (
    // div要素を返し、ドロップ可能にするための参照とスタイルを適用する
    <div ref={setNodeRef} style={style}>
      {/* このコンポーネントを使用する際に渡された子要素（テキストや他のコンポーネントなど）を表示する */}
      {props.children}
    </div>
  );

}