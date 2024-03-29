// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.dddml.suiinfinitesea.domain.skillprocessmutex.hibernate;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.dddml.suiinfinitesea.domain.*;
import org.hibernate.Session;
import org.hibernate.Criteria;
//import org.hibernate.criterion.Order;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.SessionFactory;
import org.dddml.suiinfinitesea.domain.skillprocessmutex.*;
import org.dddml.suiinfinitesea.specialization.*;
import org.dddml.suiinfinitesea.specialization.hibernate.*;
import org.springframework.transaction.annotation.Transactional;

public class HibernateSkillProcessMutexStateRepository implements SkillProcessMutexStateRepository {
    private SessionFactory sessionFactory;

    public SessionFactory getSessionFactory() { return this.sessionFactory; }

    public void setSessionFactory(SessionFactory sessionFactory) { this.sessionFactory = sessionFactory; }

    protected Session getCurrentSession() {
        return this.sessionFactory.getCurrentSession();
    }
    
    private static final Set<String> readOnlyPropertyPascalCaseNames = new HashSet<String>(Arrays.asList("PlayerId", "ActiveSkillType", "Version", "OffChainVersion", "CreatedBy", "CreatedAt", "UpdatedBy", "UpdatedAt", "Active", "Deleted"));
    
    private ReadOnlyProxyGenerator readOnlyProxyGenerator;
    
    public ReadOnlyProxyGenerator getReadOnlyProxyGenerator() {
        return readOnlyProxyGenerator;
    }

    public void setReadOnlyProxyGenerator(ReadOnlyProxyGenerator readOnlyProxyGenerator) {
        this.readOnlyProxyGenerator = readOnlyProxyGenerator;
    }

    @Transactional(readOnly = true)
    public SkillProcessMutexState get(String id, boolean nullAllowed) {
        SkillProcessMutexState.SqlSkillProcessMutexState state = (SkillProcessMutexState.SqlSkillProcessMutexState)getCurrentSession().get(AbstractSkillProcessMutexState.SimpleSkillProcessMutexState.class, id);
        if (!nullAllowed && state == null) {
            state = new AbstractSkillProcessMutexState.SimpleSkillProcessMutexState();
            state.setPlayerId(id);
        }
        if (getReadOnlyProxyGenerator() != null && state != null) {
            return (SkillProcessMutexState) getReadOnlyProxyGenerator().createProxy(state, new Class[]{SkillProcessMutexState.SqlSkillProcessMutexState.class}, "getStateReadOnly", readOnlyPropertyPascalCaseNames);
        }
        return state;
    }

    public void save(SkillProcessMutexState state) {
        SkillProcessMutexState s = state;
        if (getReadOnlyProxyGenerator() != null) {
            s = (SkillProcessMutexState) getReadOnlyProxyGenerator().getTarget(state);
        }
        if(s.getOffChainVersion() == null) {
            getCurrentSession().save(s);
        } else {
            getCurrentSession().update(s);
        }

        if (s instanceof Saveable)
        {
            Saveable saveable = (Saveable) s;
            saveable.save();
        }
        getCurrentSession().flush();
    }

    public void merge(SkillProcessMutexState detached) {
        SkillProcessMutexState persistent = getCurrentSession().get(AbstractSkillProcessMutexState.SimpleSkillProcessMutexState.class, detached.getPlayerId());
        if (persistent != null) {
            merge(persistent, detached);
            getCurrentSession().save(persistent);
        } else {
            getCurrentSession().save(detached);
        }
        getCurrentSession().flush();
    }

    private void merge(SkillProcessMutexState persistent, SkillProcessMutexState detached) {
        ((AbstractSkillProcessMutexState) persistent).merge(detached);
    }

}

