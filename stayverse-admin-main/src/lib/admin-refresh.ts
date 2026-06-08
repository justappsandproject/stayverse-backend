type AdminRefreshDetail = { scope?: "listings" | "chefs" | "hosts" | "metrics" };

export const ADMIN_REFRESH_EVENT = "stayverse:admin-refresh";

export function dispatchAdminRefresh(scope?: AdminRefreshDetail["scope"]) {
  window.dispatchEvent(
    new CustomEvent(ADMIN_REFRESH_EVENT, { detail: { scope } satisfies AdminRefreshDetail }),
  );
}

export function listenAdminRefresh(
  handler: (scope?: AdminRefreshDetail["scope"]) => void,
) {
  const listener = (event: Event) => {
    const detail = (event as CustomEvent<AdminRefreshDetail>).detail;
    handler(detail?.scope);
  };
  window.addEventListener(ADMIN_REFRESH_EVENT, listener);
  return () => window.removeEventListener(ADMIN_REFRESH_EVENT, listener);
}
