package com.moyu.common.mybatis.handler;


import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.extension.plugins.handler.MultiDataPermissionHandler;
import com.moyu.common.mybatis.annotation.DataPermission;
import com.moyu.common.security.util.SecurityUtils;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.parser.CCJSqlParserUtil;
import net.sf.jsqlparser.schema.Table;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Optional;
import java.util.Set;

/**
 * 自定义数据权限处理器
 *
 * @author shisong
 * @since 2025-02-25
 */
@Slf4j
public class CustomDataPermissionHandler implements MultiDataPermissionHandler {

    /**
     * @param table             所执行的数据库表信息，可以通过此参数获取表名和表别名
     * @param where             原有的 where 条件信息
     * @param mappedStatementId Mybatis MappedStatement Id 根据该参数可以判断具体执行方法
     * @return JSqlParser 条件表达式，返回的条件表达式会拼接在原有的表达式后面（不会覆盖原有的表达式）
     */
    @Override
    @SneakyThrows
    public Expression getSqlSegment(Table table, Expression where, String mappedStatementId) {
        // mappedStatementId 根据该参数可以判断具体执行方法，xml中为自定义名，注解中为方法签名，类似于com.xx.xxMapper.selectList
        Class<?> clazz = Class.forName(mappedStatementId.substring(0, mappedStatementId.lastIndexOf(StringPool.DOT)));
        // 只有Mapper中的方法才会被拦截到
        String methodName = mappedStatementId.substring(mappedStatementId.lastIndexOf(StringPool.DOT) + 1);
        Method[] methods = clazz.getDeclaredMethods();
        Optional<Method> optMethod = Arrays.stream(methods).filter(e -> methodName.equals(e.getName())).findFirst();
        // 若未匹配到执行的mapper方法,不做处理返回
        if (!optMethod.isPresent()) {
            return null;
        }
        DataPermission annotation = optMethod.get().getAnnotation(DataPermission.class);
        // 若匹配到的执行方法上无注解，不做处理返回
        if (annotation == null) {
            return null;
        }
        // 指定的列名
        String userColumn = annotation.userColumn();
        String orgColumn = annotation.orgColumn();
        if (StrUtil.isBlank(userColumn) && StrUtil.isBlank(orgColumn)) {
            log.debug("{}加了数据权限注解，但未指定字段名，无法追加筛选条件", mappedStatementId);
            return null;
        }
        // root超管不做任何限制
        if (SecurityUtils.isRoot()) {
            return null;
        }
        log.debug("{}设置数据了权限", mappedStatementId);
        // 匹配到的方法上有注解，则按照注解内容生成追加的表达式
        return dataScopeFilter(userColumn, orgColumn);
    }

    /**
     * 设置数据权限的语句，可在通过拦截注解此处理，也可不通过注解直接在代码中处理
     *
     * @return 构建后查询条件
     */
    @SneakyThrows
    public static Expression dataScopeFilter(String userColumn, String orgColumn) {
        // 追加的条件
        String sqlStr = "";
        // user 条件
        if (StrUtil.isNotBlank(userColumn)) {
            // 用户名
            String username = SecurityUtils.getLoginUser().getUsername();
            sqlStr = userColumn + " = '" + username + "'";
        }
        // org 条件
        if (StrUtil.isNotBlank(orgColumn)) {
            // 数据权限范围
            Set<String> scopes = SecurityUtils.getScopes();
            if (ObjectUtil.isEmpty(scopes)) {
                // 无权限
                sqlStr = "1 = 0";
            } else if (StrUtil.isBlank(sqlStr)) {
                sqlStr = orgColumn + " IN ('" + CollectionUtil.join(scopes, "', '") + "')";
            } else {
                sqlStr = sqlStr + " AND " + orgColumn + " IN ('" + CollectionUtil.join(scopes, "', '") + "')";
            }
        }
        if (StrUtil.isBlank(sqlStr)) {
            return null;
        }
        log.debug("追加的数据权限过滤条件为:{}", sqlStr);
        // 将sqlStr转换为条件表达式
        return CCJSqlParserUtil.parseCondExpression(sqlStr);
    }

}
