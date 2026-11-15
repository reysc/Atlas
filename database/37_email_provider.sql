-- 37_email_provider.sql
--
-- 邮件服务商选择：Cloudflare Email Sending（Workers Paid）或 Resend。
--
-- 语义：
--   cloudflare → 优先走 EMAIL 绑定；绑定缺失或发送失败时，若配置了
--                RESEND_API_KEY 则自动回退到 Resend
--   resend     → 始终走 Resend
--
-- 可重复执行：INSERT OR IGNORE，已存在时不覆盖管理员改动过的值。
-- 管理端位置：管理员 → 系统配置 → 邮件 → email_provider。

INSERT OR IGNORE INTO system_config (
  key, value, description, config_type, config_group, is_public, display_order,
  validation_rules, options, created_at, updated_at
) VALUES (
  'email_provider',
  'cloudflare',
  '邮件发送服务商。cloudflare = Cloudflare Email Sending（Workers Paid，优先使用）；resend = Resend。选择 cloudflare 时若绑定缺失或发送失败，且已配置 Resend，会自动回退到 Resend。',
  'select',
  'email',
  0,
  39,
  NULL,
  '[{"value":"cloudflare","label":"Cloudflare Email"},{"value":"resend","label":"Resend"}]',
  CAST(strftime('%s', 'now') AS INTEGER) * 1000,
  CAST(strftime('%s', 'now') AS INTEGER) * 1000
);
