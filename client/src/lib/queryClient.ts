import { QueryClient, QueryFunction } from "@tanstack/react-query";

async function throwIfResNotOk(res: Response) {
  if (!res.ok) {
    const text = (await res.text()) || res.statusText;
    throw new Error(`${res.status}: ${text}`);
  }
}

function isPlainObject(value: unknown): value is Record<string, unknown> {
  return (
    typeof value === "object" &&
    value !== null &&
    !Array.isArray(value) &&
    (value as any).constructor === Object
  );
}

function buildUrlFromQueryKey(queryKey: readonly unknown[]): string {
  const [first, ...rest] = queryKey;
  const base = typeof first === "string" ? first : String(first);

  if (rest.length === 0) return base;

  // Support queryKey patterns like: ["/api/services", { categoryId, location }]
  const queryObjects = rest.filter(isPlainObject) as Record<string, unknown>[];
  const nonObjects = rest.filter((v) => !isPlainObject(v));

  // If the key contains any plain object(s), treat them as query params (merged).
  if (queryObjects.length > 0) {
    const params = new URLSearchParams();
    for (const obj of queryObjects) {
      for (const [k, v] of Object.entries(obj)) {
        if (v === undefined || v === null || v === "") continue;
        params.set(k, String(v));
      }
    }

    // Preserve any non-object path segments (e.g. ["/api/foo", id, { ...filters }])
    const path =
      nonObjects.length > 0
        ? `${base}/${nonObjects.map((s) => encodeURIComponent(String(s))).join("/")}`
        : base;

    const qs = params.toString();
    return qs ? `${path}?${qs}` : path;
  }

  // Default: treat remaining key parts as path segments.
  return `${base}/${rest.map((s) => encodeURIComponent(String(s))).join("/")}`;
}

export async function apiRequest(
  method: string,
  url: string,
  data?: unknown | undefined,
): Promise<Response> {
  const res = await fetch(url, {
    method,
    headers: data ? { "Content-Type": "application/json" } : {},
    body: data ? JSON.stringify(data) : undefined,
    credentials: "include",
  });

  await throwIfResNotOk(res);
  return res;
}

type UnauthorizedBehavior = "returnNull" | "throw";
export const getQueryFn: <T>(options: {
  on401: UnauthorizedBehavior;
}) => QueryFunction<T> =
  ({ on401: unauthorizedBehavior }) =>
  async ({ queryKey }) => {
    const url = buildUrlFromQueryKey(queryKey);
    const res = await fetch(url, {
      credentials: "include",
    });

    if (unauthorizedBehavior === "returnNull" && res.status === 401) {
      return null;
    }

    await throwIfResNotOk(res);
    return await res.json();
  };

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      queryFn: getQueryFn({ on401: "throw" }),
      refetchInterval: false,
      refetchOnWindowFocus: false,
      staleTime: Infinity,
      retry: false,
    },
    mutations: {
      retry: false,
    },
  },
});
