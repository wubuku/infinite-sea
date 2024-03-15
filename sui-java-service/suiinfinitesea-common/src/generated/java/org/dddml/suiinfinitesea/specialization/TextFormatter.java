package org.dddml.suiinfinitesea.specialization;

/**
 * Created by yangjiefeng on 2018/3/6.
 */
public interface TextFormatter<T> {

    T parse(String text);

    String toString(T value);

}
