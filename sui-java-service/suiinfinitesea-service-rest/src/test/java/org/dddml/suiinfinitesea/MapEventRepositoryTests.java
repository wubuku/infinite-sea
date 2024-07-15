package org.dddml.suiinfinitesea;


import org.dddml.suiinfinitesea.domain.map.AbstractMapEvent;
import org.dddml.suiinfinitesea.sui.contract.repository.MapEventRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

@SpringBootTest//(classes = SuiInfiniteSeaApplication.class)
//这里的 @SpringBootTest 如不不指定 classes ,那么本测试的包名需与主代码的包名一致
public class MapEventRepositoryTests {
    @Autowired
    private MapEventRepository mapEventRepository;


    @Test
    @Transactional
    //@Rollback(false)
    public void testGetFirstByEventStatusIsNull() {
        AbstractMapEvent e = mapEventRepository.findFirstByEventStatusIsNull();
        if (e != null) {
            System.out.println("事件类型 Event Type is:" + e.getEventType());
        }
    }
}
