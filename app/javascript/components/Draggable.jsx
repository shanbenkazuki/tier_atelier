// Reactライブラリをインポートする
import React from 'react';
// @dnd-kit/coreから、ドラッグ可能な機能を提供するフックをインポートする
import {useDraggable} from '@dnd-kit/core';

// Draggableという関数コンポーネントを定義する
export function Draggable(props) {
  // useDraggableフックを使って、ドラッグに関連する属性、リスナー、ノードの参照、移動量を取得する
  const {attributes, listeners, setNodeRef, transform} = useDraggable({
    id: props.id,
  });
  // アイテムがドラッグされている間の移動量に基づいて、スタイルを動的に計算する
  const style = transform ? {
    transform: `translate3d(${transform.x}px, ${transform.y}px, 0)`,
  } : undefined;

  // コンポーネントのUIを返す
  return (
    // ボタン要素を返し、ドラッグをサポートするための参照、スタイル、属性、リスナーを適用する
    <button ref={setNodeRef} style={style} {...listeners} {...attributes}>
      {/* このコンポーネントを使用する際に渡された子要素（テキストや他のコンポーネントなど）を表示する */}
      {props.children}
    </button>
  );
}
