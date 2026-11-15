-- 40_email_mailjet.sql
--
-- Mailjet 邮件服务商的优先级与每日限额。
--
-- 语义与 38_email_provider_priority.sql 一致：
--   email_priority_mailjet      数值越小越优先；-1 表示停用
--   email_daily_limit_mailjet   每天成功发送上限；0 表示不限额
--
-- 可重复执行：INSERT OR IGNORE，已存在时不覆盖管理员改动过的值。
-- 管理端位置：管理员 → 系统配置 → 邮件。

INSERT OR IGNORE INTO system_config (
  key, value, description, config_type, config_group, is_public, display_order,
  validation_rules, options, created_at, updated_at
) VALUES
  (
    'email_priority_mailjet',
    '4',
    'Mailjet 邮件优先级（数值越小越优先；-1 表示停用）',
    'integer',
    'email',
    0,
    46,
    '{"min": -1, "max": 99}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  ),
  (
    'email_daily_limit_mailjet',
    '100',
    'Mailjet 每日发送上限（0 表示不限额，达到后自动使用下一优先级）',
    'integer',
    'email',
    0,
    47,
    '{"min": 0, "max": 1000000}',
    NULL,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000,
    CAST(strftime('%s', 'now') AS INTEGER) * 1000
  );
