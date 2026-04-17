import { NotificationService, type BroadcastAudience } from "@/api/notification-service";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useState } from "react";

export default function CuratedMessagesPage() {
  const [audience, setAudience] = useState<BroadcastAudience>("all");
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [sending, setSending] = useState(false);
  const [result, setResult] = useState<{
    totalEligible: number;
    sentCount: number;
    failedCount: number;
    emailSentCount?: number;
    emailFailedCount?: number;
  } | null>(null);

  const canSubmit = title.trim().length > 0 && body.trim().length > 0;

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!canSubmit) return;

    setSending(true);
    const response = await NotificationService.sendCuratedBroadcast({
      audience,
      title: title.trim(),
      body: body.trim(),
      extras: {
        source: "admin_panel",
      },
    });
    setSending(false);

    if (response) {
      setResult(response);
    }
  };

  return (
    <section className="px-10 pb-12 pt-[30px] space-y-8">
      <div className="w-full flex items-center gap-5 flex-wrap">
        <h1 className="font-medium text-dark text-[32px]">Curated Messages</h1>
        <span className="ml-auto text-sm text-[#858585]">
          Send special updates to users, agents, or everyone.
        </span>
      </div>

      <form
        onSubmit={onSubmit}
        className="max-w-3xl bg-white rounded-xl border border-[#ececec] p-6 space-y-5"
      >
        <div className="space-y-2">
          <label className="text-sm font-medium">Audience</label>
          <Select
            value={audience}
            onValueChange={(value) => setAudience(value as BroadcastAudience)}
          >
            <SelectTrigger className="w-full h-11">
              <SelectValue placeholder="Select audience" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All (Users and Agents)</SelectItem>
              <SelectItem value="user">Users only</SelectItem>
              <SelectItem value="agent">Agents only</SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2">
          <label className="text-sm font-medium">Message title</label>
          <Input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            maxLength={100}
            placeholder="e.g. Special Easter city deals are now live"
            className="h-11"
          />
        </div>

        <div className="space-y-2">
          <label className="text-sm font-medium">Message body</label>
          <textarea
            value={body}
            onChange={(e) => setBody(e.target.value)}
            maxLength={500}
            placeholder="Write your curated message..."
            className="w-full min-h-[140px] rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-xs outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]"
          />
        </div>

        <div className="flex items-center justify-between flex-wrap gap-3">
          <p className="text-xs text-[#858585]">
            Tip: keep messages short and action-oriented for better engagement.
          </p>
          <Button type="submit" disabled={!canSubmit || sending}>
            {sending ? "Sending..." : "Send curated message"}
          </Button>
        </div>
      </form>

      {result && (
        <div className="max-w-3xl bg-[#f6f6f6] rounded-xl border border-[#ececec] p-6">
          <h2 className="font-medium text-lg mb-3">Last broadcast result</h2>
          <div className="grid grid-cols-1 sm:grid-cols-5 gap-3 text-sm">
            <div className="rounded-lg bg-white p-3 border">
              <p className="text-[#858585]">Eligible recipients</p>
              <p className="font-semibold text-lg">{result.totalEligible}</p>
            </div>
            <div className="rounded-lg bg-white p-3 border">
              <p className="text-[#858585]">Sent</p>
              <p className="font-semibold text-lg text-green-700">{result.sentCount}</p>
            </div>
            <div className="rounded-lg bg-white p-3 border">
              <p className="text-[#858585]">Failed</p>
              <p className="font-semibold text-lg text-red-700">{result.failedCount}</p>
            </div>
            <div className="rounded-lg bg-white p-3 border">
              <p className="text-[#858585]">Emails sent</p>
              <p className="font-semibold text-lg text-green-700">{result.emailSentCount ?? 0}</p>
            </div>
            <div className="rounded-lg bg-white p-3 border">
              <p className="text-[#858585]">Email failed</p>
              <p className="font-semibold text-lg text-red-700">{result.emailFailedCount ?? 0}</p>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
