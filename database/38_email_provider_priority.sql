-- 38_email_provider_priority.sql
--
-- 邮件服务商优先级与每日限额。
--
-- 语义：
--   email_priority_*      数值越小越优先；-1 表示停用；相同值按
--                         Cloudflare → Resend → Mailtrap 顺序
--   email_daily_limit_*   每天成功发送上限；0 表示不限额；达到上限后
--                         自动尝试下一优先级的服务商
--   每日额度按 Asia/Shanghai 自然日统计 email_send_logs 中 sent 的记录。
--
-- 可重复执行：INSERT OR IGNORE，已存在时不覆盖管理员改动过的值。
-- 管理端位置：管理员 → 系统配置 → 邮件。

INSERT OR IGNORE INTO system_config (
  key, value, description, config_type, config_group, is_public, display_order,
  validation_rules, options, created_at, updated_at
) VALUES
  (
    'email_priority_cloudflare',
    '0',
    'Cloudflare 邮件优先级（数值越小越优先；-1 表示停用）',
    'integer',
    'email',
    0,
    33,
    '{"min": -1, "max": 99}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  ),
  (
    'email_priority_resend',
    '1',
    'Resend 邮件优先级（数值越小越优先；-1 表示停用）',
    'integer',
    'email',
    0,
    34,
    '{"min": -1, "max": 99}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  ),
  (
    'email_priority_mailtrap',
    '2',
    'Mailtrap 邮件优先级（数值越小越优先；-1 表示停用）',
    'integer',
    'email',
    0,
    35,
    '{"min": -1, "max": 99}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  ),
  (
    'email_daily_limit_cloudflare',
    '100',
    'Cloudflare 每日发送上限（0 表示不限额，达到后自动使用下一优先级）',
    'integer',
    'email',
    0,
    36,
    '{"min": 0, "max": 1000000}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  ),
  (
    'email_daily_limit_resend',
    '100',
    'Resend 每日发送上限（0 表示不限额，达到后自动使用下一优先级）',
    'integer',
    'email',
    0,
    37,
    '{"min": 0, "max": 1000000}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  ),
  (
    'email_daily_limit_mailtrap',
    '100',
    'Mailtrap 每日发送上限（0 表示不限额，达到后自动使用下一优先级）',
    'integer',
    'email',
    0,
    38,
    '{"min": 0, "max": 1000000}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  );

-- 兼容上一版 email_provider=resend 的选择：把 Resend 提为最高优先级。
UPDATE system_config
SET value = '0'
WHERE key = 'email_priority_resend'
  AND EXISTS (SELECT 1 FROM system_config WHERE key = 'email_provider' AND value = 'resend');

UPDATE system_config
SET value = '1'
WHERE key = 'email_priority_cloudflare'
  AND EXISTS (SELECT 1 FROM system_config WHERE key = 'email_provider' AND value = 'resend');

-- 旧的单选配置已由优先级替代。
DELETE FROM system_config WHERE key = 'email_provider';
