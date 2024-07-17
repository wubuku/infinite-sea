//package org.dddml.suiinfinitesea;
//
//
//import org.dddml.suiinfinitesea.domain.map.AbstractMapEvent;
//import org.dddml.suiinfinitesea.sui.contract.repository.MapEventRepository;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.transaction.annotation.Transactional;
//
//@SpringBootTest//(classes = SuiInfiniteSeaApplication.class)
////If you don't specify classes in @SpringBootTest, then the package name of this test needs to be the same as the package name of the "main" code.
//public class MapEventRepositoryTests {
//    @Autowired
//    private MapEventRepository mapEventRepository;
//
//
//    @Test
//    @Transactional
//    //@Rollback(false)
//    public void testGetFirstByEventStatusIsNull() {
//        AbstractMapEvent e = mapEventRepository.findFirstByEventStatusIsNull();
//        if (e != null) {
//            System.out.println("The Event Type is:" + e.getEventType());
//        }
//    }
//}
