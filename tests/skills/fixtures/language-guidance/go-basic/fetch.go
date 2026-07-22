package fetch

import "context"

type Client interface {
	Fetch(context.Context, string) (string, error)
}

func FetchAll(ctx context.Context, client Client, urls []string) ([]string, error) {
	results := make([]string, 0, len(urls))
	for _, url := range urls {
		result, err := client.Fetch(ctx, url)
		if err != nil {
			return nil, err
		}
		results = append(results, result)
	}
	return results, nil
}
