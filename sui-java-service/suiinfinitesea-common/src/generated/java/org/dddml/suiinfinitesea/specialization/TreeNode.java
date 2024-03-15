package org.dddml.suiinfinitesea.specialization;

public interface TreeNode<T> {
    T getContent();

    Iterable<TreeNode<T>> getChildren();
}
