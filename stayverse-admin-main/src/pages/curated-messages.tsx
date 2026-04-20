import {
  NotificationService,
  type BroadcastAudience,
  type CuratedAdminMessage,
  type ImagePosition,
  type SendMode,
} from "@/api/notification-service";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useEffect, useState } from "react";
import { toast } from "sonner";

export default function CuratedMessagesPage() {
  const [audience, setAudience] = useState<BroadcastAudience>("all");
  const [title, setTitle] = useState("");
  const [body, setBody] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [uploadingImage, setUploadingImage] = useState(false);
  const [imagePosition, setImagePosition] = useState<ImagePosition>("after");
  const [sendMode, setSendMode] = useState<SendMode>("now");
  const [scheduledAt, setScheduledAt] = useState("");
  const [sending, setSending] = useState(false);
  const [history, setHistory] = useState<CuratedAdminMessage[]>([]);
  const [result, setResult] = useState<{
    totalEligible: number;
    sentCount: number;
    failedCount: number;
    emailSentCount?: number;
    emailFailedCount?: number;
  } | null>(null);

  const canSubmit =
    title.trim().length > 0 &&
    body.trim().length > 0 &&
    (sendMode === "now" || scheduledAt.trim().length > 0);

  const loadHistory = async () => {
    const items = await NotificationService.listCuratedMessagesForAdmin(1, 20);
    setHistory(items);
  };

  useEffect(() => {
    void loadHistory();
  }, []);

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!canSubmit) return;

    let scheduledIso: string | undefined;
    if (sendMode === "scheduled") {
      const parsed = new Date(scheduledAt);
      if (Number.isNaN(parsed.getTime())) {
        toast.warning("Please select a valid schedule date and time.");
        return;
      }
      if (parsed.getTime() <= Date.now()) {
        toast.warning("Scheduled time must be in the future.");
        return;
      }
      scheduledIso = parsed.toISOString();
    }

    let uploadedImageUrl = imageUrl.trim() || undefined;
    if (selectedImage) {
      setUploadingImage(true);
      const uploadResult = await NotificationService.uploadCuratedImage(selectedImage);
      setUploadingImage(false);
      if (!uploadResult) {
        setSending(false);
        return;
      }
      uploadedImageUrl = uploadResult;
    }

    setSending(true);
    const response = await NotificationService.sendCuratedBroadcast({
      audience,
      title: title.trim(),
      body: body.trim(),
      imageUrl: uploadedImageUrl,
      imagePosition,
      sendMode,
      scheduledAt: scheduledIso,
      extras: {
        source: "admin_panel",
      },
    });
    setSending(false);

    if (response) {
      setResult(response);
      setTitle("");
      setBody("");
      setImageUrl("");
      setSelectedImage(null);
      setScheduledAt("");
      setSendMode("now");
      await loadHistory();
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

        <div className="space-y-2">
          <label className="text-sm font-medium">Image URL (optional)</label>
          <Input
            value={imageUrl}
            onChange={(e) => setImageUrl(e.target.value)}
            placeholder="https://example.com/banner.jpg"
            className="h-11"
          />
        </div>

        <div className="space-y-2">
          <label className="text-sm font-medium">Or upload image</label>
          <Input
            type="file"
            accept="image/*"
            onChange={(e) => {
              const file = e.target.files?.[0] ?? null;
              setSelectedImage(file);
            }}
            className="h-11"
          />
          {selectedImage && (
            <p className="text-xs text-[#858585]">
              Selected: {selectedImage.name}
            </p>
          )}
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div className="space-y-2">
            <label className="text-sm font-medium">Image position</label>
            <Select
              value={imagePosition}
              onValueChange={(value) => setImagePosition(value as ImagePosition)}
            >
              <SelectTrigger className="w-full h-11">
                <SelectValue placeholder="Select image position" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="before">Before text</SelectItem>
                <SelectItem value="after">After text</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div className="space-y-2">
            <label className="text-sm font-medium">Send mode</label>
            <Select
              value={sendMode}
              onValueChange={(value) => setSendMode(value as SendMode)}
            >
              <SelectTrigger className="w-full h-11">
                <SelectValue placeholder="Select send mode" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="now">Send now</SelectItem>
                <SelectItem value="scheduled">Schedule</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>

        {sendMode === "scheduled" && (
          <div className="space-y-2">
            <label className="text-sm font-medium">Scheduled date/time</label>
            <Input
              type="datetime-local"
              value={scheduledAt}
              onChange={(e) => setScheduledAt(e.target.value)}
              className="h-11"
            />
          </div>
        )}

        <div className="flex items-center justify-between flex-wrap gap-3">
          <p className="text-xs text-[#858585]">
            Tip: keep messages short and action-oriented for better engagement.
          </p>
          <Button type="submit" disabled={!canSubmit || sending || uploadingImage}>
            {uploadingImage ? "Uploading image..." : sending ? "Sending..." : "Send curated message"}
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

      <div className="max-w-4xl bg-white rounded-xl border border-[#ececec] p-6">
        <div className="flex items-center justify-between">
          <h2 className="font-medium text-lg">Recent curated messages</h2>
          <Button type="button" variant="outline" onClick={() => void loadHistory()}>
            Refresh
          </Button>
        </div>
        <div className="mt-4 space-y-3">
          {history.length === 0 && (
            <p className="text-sm text-[#858585]">No curated messages found.</p>
          )}
          {history.map((item) => (
            <div key={item._id} className="rounded-lg border border-[#ececec] p-4">
              <div className="flex flex-wrap items-center gap-2 text-xs text-[#858585]">
                <span className="px-2 py-1 bg-[#f5f5f5] rounded">{item.audience}</span>
                <span className="px-2 py-1 bg-[#f5f5f5] rounded">{item.status ?? "sent"}</span>
                <span className="px-2 py-1 bg-[#f5f5f5] rounded">{item.sendMode ?? "now"}</span>
              </div>
              <h3 className="mt-2 font-semibold">{item.title}</h3>
              <p className="text-sm text-[#4f4f4f] mt-1">{item.body}</p>
              {item.imageUrl && (
                <p className="text-xs text-[#858585] mt-2">
                  Image ({item.imagePosition ?? "after"}): {item.imageUrl}
                </p>
              )}
              <div className="mt-3 grid grid-cols-2 sm:grid-cols-4 gap-2 text-xs">
                <div className="rounded bg-[#f8f8f8] px-2 py-1">Viewed: {item.metrics?.viewedCount ?? 0}</div>
                <div className="rounded bg-[#f8f8f8] px-2 py-1">Read: {item.metrics?.readCount ?? 0}</div>
                <div className="rounded bg-[#f8f8f8] px-2 py-1">Likes: {item.metrics?.likeCount ?? 0}</div>
                <div className="rounded bg-[#f8f8f8] px-2 py-1">Dislikes: {item.metrics?.dislikeCount ?? 0}</div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
